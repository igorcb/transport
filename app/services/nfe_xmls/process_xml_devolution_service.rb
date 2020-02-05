module NfeXmls
  class ProcessXmlDevolutionService
    CPFOP_DEV = ['1201', '1202', '1203', '1204', '1208', '1209', '1410', '1411', '1503', '1504', '1505', '1506', '1553',
                 '1660', '1661', '1662', '1918', '1919', '2201', '2202', '2203', '2204', '2208', '2209', '2410', '2411',
                 '2503', '2504', '2505', '2506', '2553', '2660', '2661', '2662', '2918', '2919', '3201', '3202', '3211',
                 '3503', '3553', '5201', '5202', '5208', '5209', '5210', '5410', '5411', '5412', '5413', '5503', '5553',
                 '5555', '5556', '5660', '5661', '5662', '5918', '5919', '5921', '6201', '6202', '6208', '6209', '6210',
                 '6410', '6411', '6412', '6413', '6503', '6553', '6555', '6556', '6660', '6661', '6662', '6918', '6919',
                 '6921', '7201', '7202', '7210', '7211', '7553', '7556' ]

    def initialize(nfe_xml)
      @nfe_xml = nfe_xml
    end

    def call
      #byebug
      return {success: false, message: "NF-e XML not blank."} if @nfe_xml.blank?

      path_xml = "#{Rails.root.join('public')}" + @nfe_xml.asset.url(:original, timestamp: false)
      return {success: false, message: "File XML not exist"} if File.open(path_xml).nil?
      return {success: false, message: "NFe Xml já processado."} if @nfe_xml.processado?
      #return {success: false, message: "NF-e Xml não processado"}

      if @nfe_xml.nao_processado?
        nfe_xml = @nfe_xml
        begin
          ActiveRecord::Base.transaction do

            file = "#{Rails.root.join('public')}" + nfe_xml.asset.url(:original, timestamp: false)
            nfe = NFe::NotaFiscal.new.load_xml_serealize(file)

            carrier = NfeXml.carrier_create_or_update_xml(nfe)
            carrier_id = carrier.nil? ? nil : carrier.id

            source_client = NfeXml.client_create_or_update_xml('source', nfe)
            target_client = NfeXml.client_create_or_update_xml('target', nfe)

            peso = nfe.vol.pesoB.nil? ? nfe.vol.pesoL : nfe.vol.pesoB
            place = nfe.veiculo.placa.blank? ? '' : nfe.veiculo.placa.insert(3,'-')

            product_create_or_update(nfe)

            nfe_xml.update_attributes(issue_date: nfe.ide.dhEmi[0..9],
                                            peso: peso,
                                    peso_liquido: nfe.vol.pesoL,
                                          volume: nfe.vol.qVol,
                                          numero: nfe.ide.nNF,
                                           chave: nfe.infoProt.chNFe,
                                      valor_nota: nfe.icms_tot.vNF,
                                      carrier_id: carrier_id,
                                source_client_id: source_client.id,
                                target_client_id: target_client.id,
                                           place: place,
                                     observation: nfe.info.infCpl,
                                          status: NfeXml::TipoStatus::PROCESSADO)

            return {success: true, message: "NF-e Xml processado com sucesso."}

          end
        rescue => e
          puts e.message
          return {success: false, message: e.message}
        end
      else
        return {success: false, message: "NFe Xml já processado."}
      end
    end

    private
      def product_create_or_update(nfe)
        nfe.prod.each do |product|
          #byebug
          prod = Produto.new
          prod.attributes=(product)

          produto = Product.create_with(category_id: 6,
                                    cubagem: 0,
                                   cod_prod: prod.cProd,
                                  descricao: prod.xProd,
                                        ean: prod.cEAN,
                                   ean_trib: prod.cEANTrib,
                                        ncm: prod.NCM,
                                       cfop: prod.CFOP,
                                unid_medida: prod.uCom,
                             valor_unitario: prod.vUnTrib).find_or_create_by(cod_prod: prod.cProd)

          produto.save!
        end
      end
  end
end

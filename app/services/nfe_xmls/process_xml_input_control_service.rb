module NfeXmls
  class ProcessXmlInputControlService

    def initialize(nfe_xml)
      @nfe_xml = nfe_xml
    end

    def call

      return {success: false, message: "NF-e XML not blank."} if @nfe_xml.blank?

      path_xml = "#{Rails.root.join('public')}" + @nfe_xml.asset.url(:original, timestamp: false)
      return {success: false, message: "File XML not exist"} if File.open(path_xml).nil?
      return {success: false, message: "NFe Xml já processado."} if @nfe_xml.processado?

      if @nfe_xml.nao_processado?
        nfe_xml = @nfe_xml
  	    begin
          ActiveRecord::Base.transaction do

            file = "#{Rails.root.join('public')}" + nfe_xml.asset.url(:original, timestamp: false)
            nfe = NFe::NotaFiscal.new.load_xml_serealize(file)

            #nfe_xml = update_nfe_xmls(nfe_xml, nfe)

            source_client = NfeXml.client_create_or_update_xml('source', nfe)
            target_client = NfeXml.client_create_or_update_xml('target', nfe)

            peso = nfe.vol.pesoB.nil? ? nfe.vol.pesoL : nfe.vol.pesoB
            place = nfe.veiculo.placa.blank? ? '' : nfe.veiculo.placa.insert(3,'-')

            nfe_xml.update_attributes(peso: peso,
                              peso_liquido: nfe.vol.pesoL,
                                    volume: nfe.vol.qVol,
                                    numero: nfe.ide.nNF,
                                     chave: nfe.infoProt.chNFe,
                                valor_nota: nfe.icms_tot.vNF,
                          source_client_id: source_client.id,
                          target_client_id: target_client.id,
                                     place: place,
                               observation: nfe.info.infCpl,
                                    status: NfeXml::TipoStatus::PROCESSADO)


  					NfeXml.product_create_or_update_xml(nfe_xml.input_control, nfe_xml, nfe)
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
      def update_nfe_xmls(nfe_xml, nfe)
        source_client = NfeXml.client_create_or_update_xml('source', nfe)
        target_client = NfeXml.client_create_or_update_xml('target', nfe)

        peso = nfe.vol.pesoB.nil? ? nfe.vol.pesoL : nfe.vol.pesoB
        place = nfe.veiculo.placa.blank? ? nfe_xml.input_control.place : nfe.veiculo.placa.insert(3,'-')

        nfe_xml.update_attributes(peso: peso,
                          peso_liquido: nfe.vol.pesoL,
                                volume: nfe.vol.qVol,
                                numero: nfe.ide.nNF,
                                 chave: nfe.infoProt.chNFe,
                            valor_nota: nfe.icms_tot.vNF,
                      source_client_id: source_client.id,
                      target_client_id: target_client.id,
                                 place: place,
                           observation: nfe.info.infCpl,
                                status: NfeXml::TipoStatus::PROCESSADO)
       nfe_xml
      end

  end
end

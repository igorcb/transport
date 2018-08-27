class FileOccurrence < ActiveRecord::Base
  include SettingEdiNotfis

  belongs_to :client

  has_many :occurrences
  
  # Struct.new("Carrier", :idregistro)
  NotfisHeader = Struct.new("NotfisHeader", :idregistro, :idremetente, :iddestinatario, :data, :hora, :intercambio, :filler)
  HeaderDocument = Struct.new("HeaderDocument", :idregistro, :iddocumento, :filler)
  Shipper = Struct.new("Shipper", :idregistro, :cnpj, :ie, :endereco, :cidade, :cep, :subentidade, :dataembarque, :empresa, :filler)
  TargetClient = Struct.new("TargetClient", :idregistro, :cnpj, :ie, :endereco, :cidade, :cep, :codmunicipio, :subentidade, :area, :comunicacao, :iddestinatario, :filler)
  DataNFe = Struct.new("DataNFe", :idregistro, :numromaneio, :codigorota, :meiotransporte, :tipotransporte, :tipocarga, :condicaofrete, :serie, :numeronota, :dataemissao, :natureza, :acondicionamento, :acondicionamentos, :qtdevolumes, :valortotalnota, :pesototal, :pesocubagem, :tpicms, :seguro, :valorseguro, :valorcobrado, :placa, :planocarga,:fretepeso, :fretevalor, :valoroutrastaxas, :valortotalfrete, :acaodocumento, :valoricms, :valoricmsretido, :indicacaobonificacao, :xquantidade, :relacao)
  DataComplementary = Struct.new("DataComplementary", :idregistro, :codigooperfiscal, :tipoperiodoentrega,:datainicialentrega, :horainicialentrega, :datafinalentrega, :horafinalentrega, :idlocaldesembarque, :calculofretediferenciado, :idtabelafrete, :cgcentregue1, :seriec1, :numeroc1, :cgcentregue2, :seriec2, :numeroc2, :cgcentregue3, :seriec3, :numeroc3, :cgcentregue4, :seriec4, :numeroc4, :cgcentregue5, :seriec5, :numeroc5, :filler1, :tipoveiculo, :filler2)
  NfeItem = Struct.new("NfeItem", :idregistro, :quantvol1, :espacond1, :mercadoria1, :quantvol2, :espacond2, :mercadoria2, :quantvol3, :espacond3, :mercadoria3, :quantvol4, :espacond4, :mercadoria4, :filler)
  Carrier = Struct.new("Carrier", :razaosocial, :cnpj, :ie, :endereco, :bairro, :cidade, :cep, :codmunicipio, :subentidade, :comunicacao, :filler)
  ResponsibleFreight = Struct.new("Carrier", :idregistro, :razaosocial, :cgccpf, :ie, :endereco, :bairro, :cidade, :cep, :codmunicipio, :subentidade, :comunicacao, :filler)
  ShippingCompany = Struct.new("ShippingCompany", :idregistro, :razaosocial,:cgccpf, :inscricaoestadual, :endereco, :bairro, :cidade, :cep, :codmunicipio, :subentidade, :areafrete, :comunicacao, :filler)
  Trailler = Struct.new("Trailler", :idregistro, :valortotalnotas,:pesototalnotas,:cubagemtotalnotas,:quantidadetotalvolumes,:valortotalcobrado,:valortotalseguro,:filler)

  def self.read_file_edi_notfis(file)
 	
    file = File.open(file)
  	file_occurrence = FileOccurrence.new

    sheader = header = NotfisHeader.new
    header_document = HeaderDocument.new
    shipper = Shipper.new
    target_client = TargetClient.new
    data_nfe = DataNFe.new
    data_complementary = DataComplementary.new
    nfe_item = NfeItem.new
    carrier = Carrier.new
    responsible_freight = ResponsibleFreight.new
    shipping_company = ShippingCompany.new

    trailler = Trailler.new

    list_target_client = []
    list_data_nfe = []
    list_data_complementary = []
    list_nfe_item = []
    list_responsible_freight = []

  	i = 0
  	file.each do |line|
  		puts "line: #{i}"
  		case line[0..2]
        when "000" then header = NotfisHeader.new(file_occurrence.read_header(line, header))
        when "310" then sheader_document = HeaderDocument.new(file_occurrence.read_header_document(line, header_document))
        when "311" then sshipper = Shipper.new(file_occurrence.read_embarcadora(line, shipper))
        when "312" then 
          begin
            starget_client = TargetClient.new(file_occurrence.read_target_client(line, target_client))
            list_target_client << starget_client
          end
        when "313" then 
          begin
            sdata_nfe = DataNFe.new(file_occurrence.read_data_nfe(line, data_nfe))
            list_data_nfe << sdata_nfe
          end
        when "333" then 
          begin
            sdata_complementary = DataComplementary.new(file_occurrence.read_data_complementary(line, data_complementary))
            list_data_complementary
          end
        when "314" then 
          begin
            snfe_item = file_occurrence.read_nfe_item(line, nfe_item)
            list_nfe_item << snfe_item
          end
        when "315" then scarrier = file_occurrence.read_carrier(line, carrier)
        when "316" then sshipping_company = file_occurrence.read_shipping_company(line, shipping_company)
        when "317" then 
          begin
            sresponsible_freight = ResponsibleFreight.new(file_occurrence.read_responsible_freight(line, responsible_freight))
            list_responsible_freight << sresponsible_freight
          end
        when "318" then trailler = file_occurrence.read_trailler(line, trailler)
      end
  		i += 1
  	end
    hash = {sheader: sheader, header: header}
  	 # hash = {
    #    header: header,
    #    header_document: header_document,
    #    shipper: shipper,
    #    target_client: list_target_client,
    #    data_nfe: list_data_nfe,
    #    data_complementary: list_data_complementary,
    #    nfe_item: list_nfe_item,
    #    carrier: carrier,
    #    shipping_company: shipping_company,
    #    responsible_freight: list_responsible_freight,
    #    trailler: trailler
    #  }
  end
end


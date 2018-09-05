# encoding: UTF-8
class FileOccurrence < ActiveRecord::Base
  include SettingEdiNotfis

  belongs_to :client

  has_many :occurrences
  
  def self.read_file_edi_notfis(*file_params)
 	  
  # file = File.open(file, encoding: 'ASCII-8BIT')
    
    file = File.open(file_params.last)

    raise "Arquivo já processado pelo sistema, por favor escolher outro arquivo" if FileEdi.where(type_file: FileEdi::TypeFile::EDI_NOTFIS, name_file: file_params.first).present?
  	
    file_occurrence = FileOccurrence.new

    header = NotfisHeader.new
    header_document = HeaderDocument.new
    shipper_notfis = ShipperNotfis.new
    target_client = TargetClient.new
    data_nfe = DataNFe.new
    data_complementary = DataComplementary.new
    nfe_item = NfeItem.new
    carrier_notfis = CarrierNotfis.new
    responsible_freight = ResponsibleFreight.new
    shipping_company = ShippingCompany.new

    trailler = Trailler.new

    list_target_client = []
    list_data_nfe = []
    list_data_complementary = []
    list_nfe_item = []
    list_responsible_freight = []
    lines = []
  	i = 0
  	file.each do |line|
  		lines << line
  		case line[0..2]
        when "000" then header = file_occurrence.read_header(line, header)
        when "310" then header_document = file_occurrence.read_header_document(line, header_document)
        when "311" then shipper_notfis = file_occurrence.read_embarcadora(line, shipper_notfis)
        when "312" then 
          begin
            target_client = file_occurrence.read_target_client(line, target_client)
            list_target_client << target_client
          end
        when "313" then 
          begin
            data_nfe = file_occurrence.read_data_nfe(line, data_nfe)
            data_nfe.target_cnpj = target_client.cnpj
            list_data_nfe << data_nfe
          end
        when "333" then 
          begin
            data_complementary = file_occurrence.read_data_complementary(line, data_complementary)
            data_complementary.numeronota = data_nfe.numeronota
            list_data_complementary << data_complementary
          end
        when "314" then 
          begin
            nfe_item = file_occurrence.read_nfe_item(line, nfe_item)
            nfe_item.numeronota = data_nfe.numeronota
            list_nfe_item << nfe_item
          end
        when "315" then carrier_notfis = file_occurrence.read_carrier(line, carrier_notfis)
        when "316" then shipping_company = file_occurrence.read_shipping_company(line, shipping_company)
        when "317" then 
          begin
            responsible_freight = file_occurrence.read_responsible_freight(line, responsible_freight)
            responsible_freight.numeronota = data_nfe.numeronota
            list_responsible_freight << responsible_freight
          end
        when "318" then trailler = file_occurrence.read_trailler(line, trailler)
      end
  		i += 1
  	end
    place = list_data_nfe.first.placa.insert(3,'-')
    ActiveRecord::Base.transaction do
      embarcadora    = Shipper.where(cnpj: shipper_notfis.cnpj, name: shipper_notfis.empresa.strip).find_or_create_by(cnpj: shipper_notfis.cnpj)
      transportadora = Carrier.create_with(cnpj: carrier_notfis.cnpj, nome: carrier_notfis.razaosocial).find_or_create_by(cnpj: shipper_notfis.cnpj)

      date_boarding = Date.new(shipper_notfis.dataembarque[4..7].to_i, shipper_notfis.dataembarque[2..3].to_i, shipper_notfis.dataembarque[0..1].to_i)
      file_edi = FileEdi.create!(type_file: FileEdi::TypeFile::EDI_NOTFIS, 
                      date_file: Date.current, 
                      name_file: file_params.first, 
                        content: lines.to_s,
                  date_boarding: date_boarding,
                     shipper_id: embarcadora.id,
                     carrier_id: transportadora.id,
                          place: place,
                         weight: trailler.pesototalnotas.to_f / 100,
                         volume: trailler.quantidadetotalvolumes.to_f / 100,
                    value_total: trailler.valortotalnotas.to_f / 100,
                           qtde: list_data_nfe.count,
                      )


      list_target_client.each do |client|
        cnpj = CNPJ.new(client.cnpj).formatted
        client_other = Client.create_with(tipo_cliente: Client::TipoCliente::NORMAL, 
                        tipo_pessoa: 1, 
                    group_client_id: 7, 
                               nome: client.razaosocial, 
                           fantasia: client.razaosocial, 
                                cep: client.cep, 
                           endereco: client.endereco, 
                             numero: 's/n', 
                        complemento: '', 
                             bairro: client.bairro, 
                             cidade: client.cidade, 
                             estado: client.subentidade).find_or_create_by(cpf_cnpj: cnpj)
        notfis = file_edi.notfis.create!(place: place, date_notfis: Date.current, client_id: client_other.id)
      end
      list_data_nfe.each do |nfe|
        cnpj = CNPJ.new(nfe.target_cnpj).formatted

        source_cnpj = CNPJ.new(shipper_notfis.cnpj).formatted
        source_client = Client.where(cpf_cnpj: source_cnpj).first
        target_client = Client.where(cpf_cnpj: cnpj).first
        notfis = Notfis.includes(:client).where("clients.cpf_cnpj = ? and notfis.file_edi_id = ?", cnpj, file_edi.id).references(:client).first
        notfis.nfe_xmls.create!(status: 0, 
                                error: 0,
                            create_os: 0,
                      asset_file_name: nfe.numeronota.to_i,
                               numero: nfe.numeronota.to_i,
                                chave: nfe.numeronota.to_i,
                                 peso: nfe.pesototal.to_f / 100,
                               volume: nfe.qtdevolumes.to_f / 100,
                           valor_nota: nfe.valortotalnota.to_f / 100,
                     source_client_id: source_client.id,
                     target_client_id: target_client.id,
                                place: place
          )
      end
    end
    
  	hash = {
      header: header,
      header_document: header_document,
      shipper: shipper_notfis,
      target_client: list_target_client,
      data_nfe: list_data_nfe,
      data_complementary: list_data_complementary,
      nfe_item: list_nfe_item,
      carrier: carrier_notfis,
      shipping_company: shipping_company,
      responsible_freight: list_responsible_freight,
      trailler: trailler
    }

  end

  def client_create(client)
    result = Client.create_with(tipo_cliente: Client::TipoCliente::NORMAL, 
                        tipo_pessoa: 1, 
                    group_client_id: 7, 
                               nome: client.razaosocial, 
                           fantasia: client.razaosocial, 
                                cep: client.cep, 
                           endereco: client.endereco, 
                             numero: client.numero, 
                        complemento: '', 
                             bairro: client.bairro, 
                             cidade: client.cidade, 
                             estado: client.subentidae).find_or_create_by(cpf_cnpj: cnpj)
    result
  end
end



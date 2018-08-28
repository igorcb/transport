# encoding: UTF-8
class FileOccurrence < ActiveRecord::Base
  include SettingEdiNotfis

  belongs_to :client

  has_many :occurrences
  
  def self.read_file_edi_notfis(file)
 	  
  # file = File.open(file, encoding: 'ASCII-8BIT')
    puts ">>>>>>>>>>> File: #{file}"
    file = File.open(file)
  	
    file_occurrence = FileOccurrence.new

    header = NotfisHeader.new
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
        when "000" then header = file_occurrence.read_header(line, header)
        when "310" then header_document = file_occurrence.read_header_document(line, header_document)
        when "311" then shipper = file_occurrence.read_embarcadora(line, shipper)
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
        when "315" then carrier = file_occurrence.read_carrier(line, carrier)
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
  	 hash = {
       header: header,
       header_document: header_document,
       shipper: shipper,
       target_client: list_target_client,
       data_nfe: list_data_nfe,
       data_complementary: list_data_complementary,
       nfe_item: list_nfe_item,
       carrier: carrier,
       shipping_company: shipping_company,
       responsible_freight: list_responsible_freight,
       trailler: trailler
     }
  end
end



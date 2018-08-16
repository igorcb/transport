class Occurrence < ActiveRecord::Base
	include SettingEdiOco

	def self.generate_file(nfe_key_ids)
		#source_client = Trazes do Parametro do Filtro da tela de EDI Controller Index
		occurrence = Occurrence.new
		company = Company.first

		#nfe_keys = NfeKey.includes(:ordem_service).where(nfe_source_type: "InputControl").search(ordem_service_data_entrega_servico_eq:'2018/08/02').result
		nfe_keys = NfeKey.where(id: [nfe_key_ids])
		nfe_key = nfe_keys.first
		
		#arquivo = []
		arquivo = ""
		arquivo << occurrence.generate_header(company, nfe_key.ordem_service.billing_client) 
		arquivo << "\n"
		arquivo << occurrence.generate_body()
		arquivo << "\n"
		arquivo << occurrence.generate_body_nfe(company)
		arquivo << "\n"
		nfe_keys.each do |nfe_key|
			arquivo << occurrence.generate_nfe(nfe_key)
			arquivo << "\n"
	  end
		arquivo << "\n"
		puts arquivo
		arquivo
	end
end

class Occurrence < ActiveRecord::Base
	include SettingEdiOco

	belongs_to :file_occurrence, required: false
	belongs_to :nfe_key, required: false

	def self.generate_file(name_file, nfe_key_ids)
		#source_client = Trazes do Parametro do Filtro da tela de EDI Controller Index
		ActiveRecord::Base.transaction do
			#byebug
			occurrence = Occurrence.new
			company = Company.first

			#nfe_keys = NfeKey.includes(:ordem_service).where(nfe_source_type: "InputControl").search(ordem_service_data_entrega_servico_eq:'2018/08/02').result
			nfe_keys = NfeKey.where(id: [nfe_key_ids])
			nfe_key = nfe_keys.first
			file_occurrence = FileOccurrence.create!(client_id: nfe_key.ordem_service.billing_client, date_file: Date.current, name_file: name_file, content: nil)

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
				file_occurrence.occurrences.create!(date_occurrence: Date.current, number_nfe: nfe_key.nfe, nfe_key_id: nfe_key.id)
				arquivo << "\n"
		  end
			arquivo << "\n"
	  	FileOccurrence.where(id: file_occurrence.id).update_all(content: arquivo)
			puts arquivo
			arquivo
		end
	end
end

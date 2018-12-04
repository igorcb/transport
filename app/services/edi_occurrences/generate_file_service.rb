module EdiOccurrences
  class GenerateFileService
    #include ActionController::Streaming
    include ActionController::DataStreaming
    include ActionController::Rendering

    def initialize(nfe_key_ids)
      @nfe_key_ids = nfe_key_ids
      @sigla = Company.first.initials
    end

    def call
      #byebug
      return {success: false, message: "Select one nfe"} if @nfe_key_ids.empty?

      @nfe_key_ids = get_hash_ids(@nfe_key_ids)

      date_file = Date.current.strftime('%d%m%Y')
      hora_file = Time.current.strftime('%H%M%S')
      @name_file = "OCO#{@sigla}_#{date_file}_#{hora_file}.txt"

      #file_stream = Occurrence.generate_file(date_file, @nfe_key_ids)
      file_stream = generate_file

      File.open(Rails.root.join('public/system/', 'file_edi', @name_file), 'w') {|file| file.write(file_stream)}
      return {success: true, message: "File generate success", name_file: @name_file, date_file: date_file}

    end

    private
      def get_hash_ids(ids)
        hash_ids = []
        ids.each do |i|
          hash_ids << i.to_i
        end
        hash_ids
      end

      def generate_file
        ActiveRecord::Base.transaction do
    			#byebug
    			occurrence = Occurrence.new
    			company = Company.first

    			#nfe_keys = NfeKey.includes(:ordem_service).where(nfe_source_type: "InputControl").search(ordem_service_data_entrega_servico_eq:'2018/08/02').result
    			nfe_keys = NfeKey.where(id: [@nfe_key_ids])
    			nfe_key = nfe_keys.first
    			file_occurrence = FileOccurrence.create!(client_id: nfe_key.ordem_service.billing_client, date_file: Date.current, name_file: @name_file, content: nil)

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
    			#puts arquivo
    			arquivo
    		end
      end
  end
end

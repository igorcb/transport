class EdiOccurrenceService
  #include ActionController::Streaming
  include ActionController::DataStreaming
  include ActionController::Rendering

  def initialize(nfe_key_ids)
    @nfe_key_ids = nfe_key_ids
  end	

  def perform
    @nfe_key_ids = get_hash_ids(@nfe_key_ids)

    date_file = Date.current.strftime('%d%m%Y')
    name_file = "OCOTG_#{date_file}_SEQ.txt"

    file = Occurrence.generate_file(date_file, @nfe_key_ids)

    send_file file, filename: name_file, type: 'application/txt', disposition: 'inline'		
  end

  private
    def get_hash_ids(ids)
      hash_ids = []
      ids.each do |i|
        hash_ids << i[0].to_i
      end
      hash_ids
    end
end
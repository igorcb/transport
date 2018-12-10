class EdiOccurrenceService
  #include ActionController::Streaming
  include ActionController::DataStreaming
  include ActionController::Rendering

  def initialize(nfe_key_ids)
    puts ">>>>>>>>>>>>>>.. Ids: #{nfe_key_ids}"
    @nfe_key_ids = nfe_key_ids
  end

  def perform
    @nfe_key_ids = get_hash_ids(@nfe_key_ids)

    date_file = Date.current.strftime('%d%m%Y')
    name_file = "OCOTG_#{date_file}_SEQ.txt"

    file_stream = Occurrence.generate_file(date_file, @nfe_key_ids)

    File.open(Rails.root.join('public/system/', 'file_edi', name_file), 'w') { |file| file.write(file_stream) }

    #File.open(name_file, 'w') { |file| file.write(file_stream) }
    #send_file file, filename: name_file, type: 'application/txt', disposition: 'inline'
  end

  private
    def get_hash_ids(ids)
      hash_ids = []
      ids.each do |i|
        hash_ids << i.to_i
      end
      hash_ids
    end
end

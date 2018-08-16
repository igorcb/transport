class EdiOccurrencesController < ApplicationController

  before_filter :authenticate_user!
  #load_and_authorize_resource
  
  respond_to :html, :js, :json	

  def index
    @q = NfeKey.where(id: -1).search(params[:query])
    @nfe_keys = NfeKey.where(id: -1)
    #@nfe_keys = nfe_keys = NfeKey.includes(:ordem_service).where(nfe_source_type: "InputControl").search(ordem_service_data_entrega_servico_eq:'2018/08/02').result
    respond_with(@nfe_keys)
  end

  def search
  	@q = NfeKey.includes(:ordem_service).where(nfe_source_type: "InputControl").order("ordem_services.data_entrega_servico asc").search(params[:query])

    @nfe_keys = @q.result
    respond_with(@nfe_keys) do |format|
     format.js
    end  	
  end

  def generate_file
    nfe_key_ids = OrdemService.get_hash_ids(params[:nfe][:ids])
    file = Occurrence.generate_file(nfe_key_ids)
    puts file

    date_file = Date.current.strftime('%d%m%Y')
    send_data file, filename: "OCOTG_#{date_file}_SEQ.txt", 
                                 type: 'application/txt', 
                                 disposition: 'inline'
    #redirect_to edi_occurrences_path
  end
end

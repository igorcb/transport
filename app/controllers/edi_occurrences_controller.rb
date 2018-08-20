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
  	@q = NfeKey.includes(:ordem_service).where("nfe_keys.id not in (select occurrences.nfe_key_id from occurrences)").where(nfe_source_type: "InputControl").order("ordem_services.data_entrega_servico asc").search(params[:query])


    @nfe_keys = @q.result
    respond_with(@nfe_keys) do |format|
     format.js
    end  	
  end

  def generate_file
    #EdiOccurrenceService.new(params[:nfe][:ids]).perform
    #flash[:success] = 'Arquivo sendo gerado aguarde...'
    #redirect_to edi_occurrences

    nfe_key_ids = OrdemService.get_hash_ids(params[:nfe][:ids])
    date_file = Date.current.strftime('%d%m%Y')
    name_file = "OCOTG_#{date_file}_SEQ.txt"

    file = Occurrence.generate_file(date_file, nfe_key_ids)

    send_data file, filename: name_file, type: 'application/txt', disposition: 'inline'   
  end
end

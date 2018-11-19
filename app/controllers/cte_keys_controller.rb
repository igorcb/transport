class CteKeysController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_cancel, only: [:show, :confirmation]
  load_and_authorize_resource
	  
  def request_cancellation
    @ordem_service = params[:ordem_service_id]
    @cte_key = CteKey.find(params[:cte_key_id])
    @cancellation = Cancellation.new
  end
end

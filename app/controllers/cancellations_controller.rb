class CancellationsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_cancel, only: [:show, :confirmation]
  load_and_authorize_resource
  respond_to :html

  
  def index
  	@cancellations = Cancellation.order('id desc')
  end

	def show
  	
  end

  def confirmation
  	Cancellation.confirm(current_user.id, params[:id])
  	redirect_to cancellation_path(params[:id]), flash: { success: "Confirmations was successful." }
  end
  
  private 
  	def set_cancel
  		@cancellation = Cancellation.find(params[:id])
  	end
  
end

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

  def rejeted
    Cancellation.confirm(current_user.id, params[:id])
    redirect_to cancellation_path(params[:id]), flash: { success: "Cancellation rejeted was successful." }
  end

  def create
    case params[:cancellation][:cancellation_type]
      when "OrdemService" then @model = OrdemService.find(params[:cancellation][:cancellation_id])
      when "Occurrence" then @model = Occurrence.find(params[:comment][:comment_id])
    end
    @cancellation = @model.cancellations.build(cancellation_params)
    @cancellation.solicitation_user_id = current_user.id
    if @cancellation.save!
      #@comment.send_notification_email
      flash[:success] = "Cancellation created!"
      case params[:cancellation][:cancellation_type] 
        when "OrdemService" then redirect_to ordem_service_path (@model)
        when "Occurrence" then redirect_to occurrence_path (@model)
      end
    else
      flash[:danger] = "Error Cancellation!"
      case params[:cancellation][:cancellation_type] 
        when "OrdemService" then redirect_to ordem_service_path (@model)
        when "Occurrence" then redirect_to occurrence_path (@model)
      end
    end
    
  end
  
  private 
  	def set_cancel
  		@cancellation = Cancellation.find(params[:id])
  	end

    def cancellation_params
      params.require(:cancellation).permit(:solicitations_user_id, :authorization_user_id, :observacao, :cancellation_type, :cancellation_id)
    end
  
end

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
  	if Cancellation.confirm?(current_user.id, params[:id])
  	  redirect_to cancellation_path(params[:id]), flash: { success: "Confirmations was successful." }
    else
      redirect_to cancellation_path(params[:id]), flash: { danger: "Error confirming cancellation!." }
    end
  end

  def rejeted
    Cancellation.confirm(current_user.id, params[:id])
    redirect_to cancellation_path(params[:id]), flash: { success: "Cancellation rejeted was successful." }
  end

  def create
    @model = cancellation_model
    @cancellation = @model.cancellations.build(cancellation_params)
    @cancellation.solicitation_user_id = current_user.id
    if @cancellation.save!
      #@comment.send_notification_email
      flash[:success] = "Cancellation created!"
      redirect_to_model
    else
      flash[:danger] = "Error Cancellation!"
      redirect_to_model
    end
    
  end
  
  private 
  	def set_cancel
  		@cancellation = Cancellation.find(params[:id])
  	end

    def cancellation_params
      params.require(:cancellation).permit(:solicitations_user_id, :authorization_user_id, :observacao, :cancellation_type, :cancellation_id)
    end
  
    def cancellation_model
      case params[:cancellation][:cancellation_type] 
        when "Billing" then Billing.find(params[:cancellation][:cancellation_id])
        when "Boarding" then Boarding.find(params[:cancellation][:cancellation_id])
        when "OrdemService" then OrdemService.find(params[:cancellation][:cancellation_id])
        when "AccountPayable" then AccountPayable.find(params[:cancellation][:cancellation_id])
        when "NfsKey" then NfsKey.find(params[:cancellation][:cancellation_id])
        when "CteKey" then CteKey.find(params[:cancellation][:cancellation_id])
        when "InputControl" then InputControl.find(params[:cancellation][:cancellation_id])
        when "OfferCharge" then OfferCharge.find(params[:cancellation][:cancellation_id])
      end
    end

    def redirect_to_model
      case params[:cancellation][:cancellation_type] 
        when "Billing" then redirect_to billing_path (@model)
        when "Boarding" then redirect_to boarding_path (@model)
        when "OrdemService" then redirect_to ordem_service_path (@model)
        when "AccountPayable" then redirect_to account_payable_path (@model)
        when "NfsKey" then redirect_to ordem_service_path (NfsKey.ordem_service(@model))
        when "CteKey" then redirect_to ordem_service_path (CteKey.ordem_service(@model))
        when "InputControl" then redirect_to input_control_path (@model)
        when "OfferCharge" then redirect_to offer_charge_path (@model)
      end
    end

end

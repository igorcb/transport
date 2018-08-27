class OrdemServiceTypeServicesController < ApplicationController
	before_filter :authenticate_user!
  before_action :set_ordem_service_type_service, only: [:show, :edit, :update, :destroy]
	respond_to :html, :js
	
	def index
    @q = OrdemServiceTypeService.where(id: -1).order('id desc').search(params[:q])
    @ordem_service_type_services = @q.result
	end

	def search
		#data = 1.day.ago.strftime('%Y-%m-%d')
    #@q = OrdemServiceTypeService.everyday(data).search(params[:q])
    @q = OrdemServiceTypeService.both.search(params[:q])
    @ordem_service_type_services = @q.result
  end

  def send_email
    @q = OrdemServiceTypeService.both.search(params[:q])
    @ordem_service_type_services = @q.result
  	#OrdemServiceTypeService.send_report
  	OrdemServiceTypeServiceMailer.report_mailer(@ordem_service_type_services).deliver!
  	#@user.send_password_reset_email
    flash[:info] = "Email sent with ordem_service_type_services"
    redirect_to ordem_service_type_services_path
  end

  def show
    respond_with(@ordem_service_type_service)
  end

  def edit
    
  end

  def create
    @ordem_service_type_service = OrdemServiceTypeService.new(ordem_service_type_service_params)
    client_table_price = ClientTablePrice.where(client_table_price_id: @ordem_service_type_service.ordem_service.billing_client, 
                                                      type_service_id: @ordem_service_type_service.type_service_id,
                                                     stretch_route_id: @ordem_service_type_service.stretch_route_id).first
    @ordem_service_type_service.client_table_price_id = client_table_price.id
    respond_to do |format|
      if @ordem_service_type_service.save!
        format.json { render action: 'show', status: :created, location: @ordem_service_type_service }
        format.js   { render action: 'show', status: :created, location: @ordem_service_type_service }
      else
        format.json { render json: @ordem_service_type_service.errors, status: :unprocessable_entity }
      end

    end    
  end

  def update
    respond_to do |format|
      if @ordem_service_type_service.update(ordem_service_type_service_params)
        format.html { redirect_to @ordem_service_type_service, flash: { success: 'OrdemServiceTypeService was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ordem_service_type_service.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @ordem_service_type_service.destroy
    respond_with(@ordem_service_type_service)
  end  

  private

    def set_ordem_service_type_service
      @ordem_service_type_service = OrdemServiceTypeService.find(params[:id])
    end

    def ordem_service_type_service_params
      params.require(:ordem_service_type_service).permit(:ordem_service_id, :stretch_route_id, :type_service_id, :advance_money_number, :valor, :status_login)
    end
end

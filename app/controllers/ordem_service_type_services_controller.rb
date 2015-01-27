class OrdemServiceTypeServicesController < ApplicationController
	before_filter :authenticate_user!
	respond_to :html
	
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
end

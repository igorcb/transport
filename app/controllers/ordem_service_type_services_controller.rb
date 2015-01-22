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
end

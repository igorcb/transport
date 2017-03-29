class NewOrdemServicesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_ordem_service, only: [:show, :edit, :update, :destroy, :close_os ]
  #load_and_authorize_resource :class => OrdemService
	
	def select_xml_nfe
			
	end

	def process_xml_nfe
		redirect_to ordem_services_path

	end	

	def index

	end
end

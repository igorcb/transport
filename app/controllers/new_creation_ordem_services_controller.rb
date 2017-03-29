require 'nokogiri'
class NewCreationOrdemServicesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_ordem_service, only: [:show, :edit, :update, :destroy, :close_os ]
  load_and_authorize_resource :class => OrdemService
	
	def select_xml_nfe
			
	end

	def process_xml_nfe
		file = params["file"]
		path_full = "#{file.path}/#{file.original_filename}"
		puts ">>>>>>>>>>>>>>>>>>> file_path: #{path_full}"
		doc = Nokogiri::XML(File.open(path_full))
		ide = doc.elements.css('ide')
		ide.children.each {|i| puts i}

		redirect_to ordem_services_path

	end	

	def index

	end	
end

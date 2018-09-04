class EdiNotfisController < ApplicationController

	def index
		@file_edi = FileEdi.order(date_boarding: :desc)
		
	end

	def show
		@file_edi = FileEdi.find(params[:id])
		@notfis = @file_edi.notfis.order(:date_notfis)
	end

	#form upload file
	def select
		
	end

	def upload
		@file_occurrences = FileOccurrence.read_file_edi_notfis(params[:file].original_filename, params[:file].path)
		redirect_to edi_notfis_index_path
	end
end

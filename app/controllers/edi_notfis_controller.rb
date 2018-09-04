class EdiNotfisController < ApplicationController

	def index
		@file_edi = FileEdi.first
		@notfis = Notfis.order(:date_notfis)
	end

	#form upload file
	def select
		
	end

	def upload
		@file_occurrences = FileOccurrence.read_file_edi_notfis(params[:file].original_filename, params[:file].path)
		redirect_to edi_notfis_index_path
	end
end

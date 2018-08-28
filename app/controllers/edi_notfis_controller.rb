class EdiNotfisController < ApplicationController

	def index
		
	end

	def upload
		@notfis = FileOccurrence.read_file_edi_notfis(params[:file].path)
	end
end

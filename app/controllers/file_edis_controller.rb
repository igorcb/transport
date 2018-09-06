class FileEdisController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

	def index
		@q = FileEdi.where(id: -1).search(params[:query])
		@file_edis = FileEdi.order(date_boarding: :desc)
    respond_with(@file_edis)		
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
		redirect_to file_edis_path
	end

	def search
    @q = FileEdi.order(date_boarding: :desc).search(params[:query])
    @file_edis = @q.result
    respond_with(@file_edis) do |format|
      format.js
    end
	end
end

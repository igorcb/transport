class NotfisController < ApplicationController
  before_action :authenticate_user!
  respond_to :html

	def index
		@q = Notfis.where(id: -1).search(params[:query])
		@notfis = Notfis.order(id: :desc)
    respond_with(@file_edis)		
	end

	def show
		@notfis = Notfis.find(params[:id])
	end

	def search
    @q = Notfis.order(id: :desc).search(params[:query])
    @notfis = @q.result
    respond_with(@notfis) do |format|
      format.js
    end
	end
end

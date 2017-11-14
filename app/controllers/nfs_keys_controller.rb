class NfsKeysController < ApplicationController
  before_filter :authenticate_user!
  #before_action :set_cancel, only: [:show, :confirmation]
  load_and_authorize_resource
	
	def	request_cancellation
		@ordem_service = params[:ordem_service_id]
		@nfs_key = NfsKey.find(params[:nfs_key_id])
		@cancellation = Cancellation.new
	end
end

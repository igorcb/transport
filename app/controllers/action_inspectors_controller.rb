class ActionInspectorsController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_account_receivable, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html

	def index
		@action_inspectors = NfeKey.where(take_dae: true, action_inspector_file_name: nil)
	end
end

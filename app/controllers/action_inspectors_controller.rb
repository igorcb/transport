class ActionInspectorsController < ApplicationController

	def index
		@action_inspectors = NfeKey.where(take_dae: true, action_inspector_file_name: nil)
	end
end

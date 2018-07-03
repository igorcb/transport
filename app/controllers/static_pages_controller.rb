class StaticPagesController < ApplicationController
	before_filter :authenticate_user!	
	
  def home
  	
  end

  def dashboard_agent

	end

	def dashboard_visit

	end

	def dashboard_client
		
	end

	def dashboard_oper
		@boardings = Boarding.the_day
		#@boardings = Boarding.status_open
	end
end

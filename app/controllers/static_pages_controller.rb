class StaticPagesController < ApplicationController
	
  def home
  	
  end

  def dashboard_agent

	end

	def dashboard_visit

	end

	def dashboard_client
		
	end

	def dashboard_oper
		@boardings = Boarding.where(status: Boarding::TipoStatus::ABERTO)
	end
end

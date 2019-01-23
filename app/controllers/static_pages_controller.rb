class StaticPagesController < ApplicationController
	before_action :authenticate_user!

  def home

  end

  def dashboard_agent

	end

	def dashboard_visit

	end

	def dashboard_client

	end

	def dashboard_oper

	end

	def dashboard_sup

	end

	def dashboard_port
		#@boardings = Boarding.the_day
		@checkins = Array.new
		driver_cpf_array = Checkin.the_day.inside_all.order(created_at: :asc).pluck(:driver_cpf).uniq
		driver_cpf_array.each do |cpf|
			@checkins.push(Checkin.driver_status(cpf))
		end
		@checkins
	end

	def dashboard_boarding
    @opened = Boarding.where(status: [Boarding::TipoStatus::ABERTO]).count
    @opened_the_day = Boarding.the_day.where(status: [Boarding::TipoStatus::ABERTO]).count
    @boarded = Boarding.where(status: [Boarding::TipoStatus::EMBARCADO]).count
    @boarded_the_day = Boarding.the_day.where(status: [Boarding::TipoStatus::EMBARCADO]).count
    @delivered = Boarding.where(status: [Boarding::TipoStatus::ENTREGUE]).count
    @delivered_the_day = Boarding.the_day.where(status: [Boarding::TipoStatus::ENTREGUE]).count
  end

	def calculate_liquidity

	end

	def phones
	  #code
	end
end

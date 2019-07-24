class StaticPagesController < ApplicationController
	before_action :authenticate_user!

  def home

  end

  def dashboard_agent

	end

	def dashboard_admin
		last_day = 3
		@inputs_daily = InputControl.where("date_scheduled > ?", Date.current - last_day.days).group_by_day(:date_scheduled).count
		@carriers = InputControl.joins(:carrier).where("input_controls.created_at > ?", Date.current - last_day.days).select("carriers.nome").group("carriers.nome").count(:id)
		@input_weight = InputControl.where("input_controls.date_scheduled > ?", Date.current - last_day.days).sum(:weight)
		@input_volume = InputControl.where("input_controls.date_scheduled > ?", Date.current - last_day.days).sum(:volume)
		@inputs_num = InputControl.where("input_controls.date_scheduled > ?", Date.current - last_day.days).count
		@boardings_num = Boarding.where("date_boarding > ?",Date.current - last_day.days).count
	end

	def dashboard_visit

	end

	def dashboard_client

	end

	def dashboard_oper

	end

	def dashboard_sup
		@checkins_boardings = Checkin.boarding.input.order(id: :asc).the_day
		@checkins_input_controls = Checkin.input_control.input.order(id: :asc).the_day
	end

	def dashboard_port
		#@boardings = Boarding.the_day
		# @checkins = Array.new
		# driver_cpf_array = Checkin.the_day.inside_all.order(created_at: :asc).pluck(:driver_cpf).uniq
		# driver_cpf_array.each do |cpf|
		# 	@checkins.push(Checkin.driver_status(cpf))
		# end
		# @checkins

		@checkins_boardings = Checkin.boarding.input.order(id: :asc).the_day
		@checkins_input_controls = Checkin.input_control.input.order(id: :asc).the_day
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

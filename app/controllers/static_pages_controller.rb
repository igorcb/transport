class StaticPagesController < ApplicationController
	before_action :authenticate_user!

  def home

  end

  def dashboard_agent

	end

	def dashboard_admin
		last_day = 30
		@inputs_daily = dashboard_date(InputControl.where("date_scheduled > ?", Date.current - last_day.days)
												.group_by_day(:date_scheduled, time_zone: false)
												.count,
												"%d %b")
		@boardings_daily = dashboard_date(Boarding.where("created_at > ?", Date.current - last_day.days)
												.group_by_day(:created_at, time_zone: false)
												.count,
												"%d %b")
		@carriers = InputControl.joins(:carrier).where("input_controls.created_at > ?", Date.current - last_day.days)
														.select("carriers.fantasia")
														.group("carriers.fantasia")
														.order("carriers.fantasia")
														.count(:id)

		# parte do input status
		@input_status = InputControl.where("date_scheduled > ?", Date.current - last_day.days).group("date_scheduled")
		@boarding_status = Boarding.where("created_at > ?", Date.current - last_day.days).group("created_at")

		@input_weight = InputControl.where("date_scheduled > ?", Date.current - last_day.days).sum(:weight)
		@input_volume = InputControl.where("date_scheduled > ?", Date.current - last_day.days).sum(:volume)
		@inputs_num = InputControl.where("date_scheduled > ?", Date.current - last_day.days).count

		@boardings_num = Boarding.where("date_boarding > ?",Date.current - last_day.days).count
		# @boardings_weight = Boarding.where("created_at > ?", Date.current - last_day.days).peso_bruto.sum()
		# @boardings_volume = Boarding.where("created_at > ?", Date.current - last_day.days).volume_total.sum()

    @boarding_weight = Boarding.joins(:nfe_keys).where("date_boarding > ?", Date.current - 30.days).sum("nfe_keys.peso")
		@boarding_volume = Boarding.joins(:nfe_keys).where("date_boarding > ?", Date.current - 30.days).sum("nfe_keys.volume")
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


	private
	def dashboard_date object, string_format='%a, %d %b %Y'
		string = {}
		object.each do |key, value|
		  string[key.strftime(string_format)] = value
		end

		string
	end

end

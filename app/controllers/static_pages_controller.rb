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
		@input_status_open = InputControl.where(status: InputControl::TypeStatus::OPEN).where("date_scheduled > ?", Date.current - last_day.days)
		@input_status_received = InputControl.where(status: InputControl::TypeStatus::RECEIVED).where("date_scheduled > ?", Date.current - last_day.days)
		@input_status_finish_typing = InputControl.where(status: InputControl::TypeStatus::FINISH_TYPING).where("date_scheduled > ?", Date.current - last_day.days)
		@input_status_discharge = InputControl.where(status: InputControl::TypeStatus::DISCHARGE).where("date_scheduled > ?", Date.current - last_day.days)

		@boarding_status = Boarding.where("created_at > ?", Date.current - last_day.days).group("created_at")
		# @ordem_services_status = OrdemService.where("data > ?", Date.current - 30.days).group(:status).count

		@input_weight = InputControl.where("date_scheduled > ?", Date.current - last_day.days).sum(:weight)
		@input_volume = InputControl.where("date_scheduled > ?", Date.current - last_day.days).sum(:volume)
		@inputs_num = InputControl.where("date_scheduled > ?", Date.current - last_day.days).count

		@boardings_num = Boarding.where("date_boarding > ?",Date.current - last_day.days).count
		# @boardings_weight = Boarding.where("created_at > ?", Date.current - last_day.days).peso_bruto.sum()
		# @boardings_volume = Boarding.where("created_at > ?", Date.current - last_day.days).volume_total.sum()

    @boarding_weight = Boarding.joins(:nfe_keys).where("date_boarding > ?", Date.current - last_day.days).sum("nfe_keys.peso")
		@boarding_volume = Boarding.joins(:nfe_keys).where("date_boarding > ?", Date.current - last_day.days).sum("nfe_keys.volume")
		@pallets_of_nfe_xml = NfeXml.where(qtde_pallet: nil).where("created_at >= ? and created_at < ? ", Date.current - last_day.day, Date.current)
		# @next_ordem_service_peso = OrdemService.where("data > ? and data <= ?", Date.current, Date.current + 3.day).group(:data).sum(:peso)
		@ordem_service_open = OrdemService.where("created_at > ?", Date.current - last_day.days).where("status = ?", OrdemService::TipoStatus::ABERTO)
		@ordem_service_waiting_boarding = OrdemService.where("created_at > ?", Date.current - last_day.days).where("status = ?", OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
		@ordem_service_boarding = OrdemService.where("created_at > ?", Date.current - last_day.days).where("status = ?", OrdemService::TipoStatus::EMBARCADO)
		@ordem_service_delivery = OrdemService.where("created_at > ?", Date.current - last_day.days).where("status = ?", OrdemService::TipoStatus::ENTREGA_EFETUADA)
		@ordem_service_close = OrdemService.where("created_at > ?", Date.current - last_day.days).where("status = ?", OrdemService::TipoStatus::FECHADO)
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

		#@next_ordem_service_peso = OrdemService.where("data > ? and data <= ?", Date.current, Date.current + 3.day).group(:data).sum(:peso)
		@next_ordem_service_peso = Boarding.where("date_boarding > ? and date_boarding <= ?", Date.current, Date.current + 3.day).group(:date_boarding).count(:id)
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
		@boarding_boardings = Boarding.where(date_boarding: Date.current)
		@checkins_boardings = Checkin.boarding.input.order(id: :asc).the_day
    # @opened = Boarding.where(status: [Boarding::TipoStatus::ABERTO]).count
    # @opened_the_day = Boarding.the_day.where(status: [Boarding::TipoStatus::ABERTO]).count
    # @boarded = Boarding.where(status: [Boarding::TipoStatus::EMBARCADO]).count
    # @boarded_the_day = Boarding.the_day.where(status: [Boarding::TipoStatus::EMBARCADO]).count
    # @delivered = Boarding.where(status: [Boarding::TipoStatus::ENTREGUE]).count
    # @delivered_the_day = Boarding.the_day.where(status: [Boarding::TipoStatus::ENTREGUE]).count
  end

	def dashboard_input
		@input_controls = InputControl.the_day
		@checkins_input_controls = Checkin.input.input.order(id: :asc).the_day
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

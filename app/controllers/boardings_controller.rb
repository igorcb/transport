class BoardingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_boarding, only: [:show, :edit, :update, :destroy, :lower, :print]
  load_and_authorize_resource
  #respond_to :js, :html, :json, :pdf

	def selection_shipment
		@ordem_services = OrdemService.where(status: OrdemService::TipoStatus::ABERTO)
	end

	def search_ordem_service
		@ordem_service = OrdemService.find(params[:boarding_items][:ordem_service_id])
    respond_with(@ordem_service) do |format|
      format.js
    end
	end

  def cancellation
    #@boarding.cancel
    #redirect_to boarding_url(@boarding_item), flash: { success: "Status update successfully..." }
  end

  def index
    @boardings = Boarding.order(id: :desc)
    #@boardings = Boarding.status_open
  end

	def show
    @account_payable = AccountPayable.new
    @cancellation = @boarding.cancellations.build
	end

	def new

	end

	def edit

	end

	def create
    respond_to do |format|
      if @boarding = Boarding.generate_shipping(params[:os][:ids]) #deve retornar o id
        format.html { redirect_to @boarding, flash: { success: "Boarding was successfully created." } }
        format.json { render action: 'show', status: :created, location: @boarding }
      else
        format.html { render action: 'new' }
        format.json { render json: @carrier.errors, status: :unprocessable_entity }
      end
    end
	end

	def update
    respond_to do |format|
      if @boarding.update(boarding_params)
        format.html { redirect_to @boarding, flash: { success: "Boarding was successfully updated." }  }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @boarding.errors, status: :unprocessable_entity }
      end
    end
	end

	def destroy
    @boarding.destroy
    respond_to do |format|
      format.html { redirect_to boardings_url }
      format.json { head :no_content }
    end
  end

  def print
    respond_to do |format|
      format.html
      format.pdf { render_print_boarding(@boarding) }
      # format.pdf do
      #   render pdf: render_quitter(@lower)
      # end
    end
  end

	private

		def set_boarding
			@boarding = Boarding.find(params[:id])	
      @boarding_items = @boarding.boarding_items.order(:row_order) if @boarding.boarding_items.present?
      @boarding_item = BoardingItem.new
		end

    def boarding_params
      params.require(:boarding).permit(:date_boarding, :driver_id, :carrier_id, :value_boarding, :safe_rctr_c, 
        :safe_optional, :number_tranking, :obs,
        board_items_attributes: [:delivery_number, :ordem_service_id, :id, :_destroy],
        boarding_vehicles_attributes: [:boarding_vehicles_id, :vehicle_id, :id, :_destroy]

      	)
    end

    def render_print_boarding(boarding)
      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'embarque.tlf')
      # valor = (quitter.total_pago.to_f * 100).to_i
      # local_data = "FORTALEZA, #{l Date.today , format: :long }"
      report.start_new_page

      report.page.item(:agent_cnpj).value(boarding.carrier.cnpj)
      report.page.item(:agent_name).value(boarding.carrier.nome)
      report.page.item(:agent_address).value(boarding.carrier.endereco + ',' + boarding.carrier.numero)
      report.page.item(:agent_complement).value(boarding.carrier.complemento)
      report.page.item(:agent_district_city).value(boarding.carrier.distric_city_state_cep)

      report.page.item(:driver_cpf).value(boarding.driver.cpf)
      report.page.item(:driver_name).value(boarding.driver.nome)
      report.page.item(:driver_address).value(boarding.driver.endereco + ',' + boarding.driver.numero)
      report.page.item(:driver_complement).value(boarding.driver.complemento)
      report.page.item(:driver_district_city).value(boarding.driver.distric_city_state_cep)


      boarding.boarding_items.order(:row_order).each do |item|
        report.list.add_row do |row|
          row.values(ent: item.delivery_number)
          row.values(os: item.ordem_service.id)
          row.values(data: date_br(item.ordem_service.data))
          row.values(cliente: item.ordem_service.client.nome)
          row.values(cidade: item.ordem_service.client.cidade + '-' + item.ordem_service.client.estado)
          row.values(nfes: item.ordem_service.get_number_nfe)
          row.values(peso: "#{number_to_currency(item.ordem_service.peso, precision: 3, unit: "", separator: ",", delimiter: ".")}")
          row.values(volume: "#{number_to_currency(item.ordem_service.qtde_volume, precision: 3, unit: "", separator: ",", delimiter: ".")}")
        end
        # report.page.item(:ent).value(item.delivery_number)
        # report.page.item(:os).value(item.ordem_service.id)
        # report.page.item(:data).value(date_br(item.ordem_service.data))
        # report.page.list(:cliente).value(item.ordem_service.client.nome)
        # report.page.item(:cidade).value(item.ordem_service.client.cidade + '-' + item.ordem_service.client.estado)
      end
      send_data report.generate, filename: "embarque_#{boarding.id}_.pdf", 
                                   type: 'application/pdf', 
                                   disposition: 'inline'


    end
end

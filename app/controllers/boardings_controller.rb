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

      emitido = "EMITIDO EM: #{date_br(Date.current)} as #{time_br(Time.current)} por #{current_user.email} - IP. #{current_user.current_sign_in_ip}"

      # cabecalho esquerdo
      report.page.item(:emb).value("EMBARQUE Nº L7/CE #{boarding.id}")
      report.page.item(:emb_1).value(boarding.id)
      report.page.item(:agent_cnpj).value(boarding.carrier.cnpj)
      report.page.item(:agent_name).value(boarding.carrier.nome)
      report.page.item(:agent_address).value(boarding.carrier.endereco + ',' + boarding.carrier.numero)
      report.page.item(:agent_complement).value(boarding.carrier.complemento)
      report.page.item(:agent_district_city).value(boarding.carrier.distric_city_state_cep)
      # cabecalho direito
      report.page.item(:driver_cpf).value(boarding.driver.cpf)
      report.page.item(:driver_name).value(boarding.driver.nome)
      report.page.item(:driver_address).value(boarding.driver.endereco + ',' + boarding.driver.numero)
      report.page.item(:driver_complement).value(boarding.driver.complemento)
      report.page.item(:driver_district_city).value(boarding.driver.distric_city_state_cep)
      #rodape
      report.page.item(:data_expedicao).value(date_br(boarding.date_boarding))
      report.page.item(:peso_bruto).value("#{number_to_currency(boarding.peso_bruto, precision: 3, unit: "", separator: ",", delimiter: ".")}")
      report.page.item(:volume_total).value("#{number_to_currency(boarding.volume_total, precision: 3, unit: "", separator: ",", delimiter: ".")}")
      report.page.item(:canhoto_cte).value(boarding.qtde_cte)
      report.page.item(:canhoto_nfe).value(boarding.qtde_nfe)
      report.page.item(:qtde_paletes).value(boarding.qtde_palets)
      report.page.item(:qtde_entregas).value(boarding.qtde_entregas)
      report.page.item(:data_and_hora).value(emitido)
      #lista veiculos
      boarding.boarding_vehicles.each do |item|
        report.list(:list_veiculos).add_row do |row|
          row.values(tipo_veiculo: item.vehicle.tipo_nome)
          row.values(placa: "#{item.vehicle.placa} #{item.vehicle.estado}" )
          row.values(antt: item.vehicle.antt)
        end
      end
      #lista ordem de servico
      boarding.boarding_items.order(:row_order).each do |item|
        report.list(:list_ordem_service).add_row do |row|
          row.values(ent: item.delivery_number)
          row.values(os: item.ordem_service.id)
          row.values(data: date_br(item.ordem_service.data))
          row.values(cliente: item.ordem_service.client.nome)
          row.values(cidade: item.ordem_service.client.cidade + '-' + item.ordem_service.client.estado)
          row.values(peso: "#{number_to_currency(item.ordem_service.peso, precision: 3, unit: "", separator: ",", delimiter: ".")}")
          row.values(volume: "#{number_to_currency(item.ordem_service.qtde_volume, precision: 3, unit: "", separator: ",", delimiter: ".")}")
          if item.ordem_service.nfe_keys.count > 1
            item.ordem_service.nfe_keys.each do |nfe|
              report.list(:list_ordem_service).add_row do |row_two|
                row_two.values(nfes: nfe.nfe)
              end
            end
          else
            row.values(nfes: item.ordem_service.get_number_nfe)
          end
          #row.values(nfes: item.ordem_service.get_number_nfe)
        end
      end
      send_data report.generate, filename: "embarque_#{boarding.id}_.pdf", 
                                   type: 'application/pdf', 
                                   disposition: 'inline'


    end
end


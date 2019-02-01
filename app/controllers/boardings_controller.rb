class BoardingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_boarding, only: [:show, :edit, :update, :destroy, :lower, :print, :letter_freight]
  load_and_authorize_resource
  respond_to :js, :html

	def selection_shipment
    @q = OrdemService.includes(:client, :driver, :nfe_keys).where(status: OrdemService::TipoStatus::ABERTO).search(params[:query])
		@ordem_services = @q.result
	end

  def selection_shipment_search
    if params[:region].blank?
      @q = OrdemService.includes(:client, :driver, :cte_keys, :nfe_keys, :nfs_keys, :ordem_service_logistics, :ordem_service_type_service).where(status: OrdemService::TipoStatus::ABERTO).search(params[:query])
    else
      region = MicroRegion.find(params[:region])
      @q = OrdemService.includes(:client, :driver, :cte_keys, :nfe_keys, :nfs_keys, :ordem_service_logistics, :ordem_service_type_service).where(status: OrdemService::TipoStatus::ABERTO).search(cidade_in_all: region.cities)
    end
    @ordem_services = @q.result
    respond_with(@ordem_services) do |format|
      format.js
    end
  end

	def search_ordem_service
		@ordem_service = OrdemService.find(params[:boarding_items][:ordem_service_id])
    respond_with(@ordem_service) do |format|
      format.js
    end
	end

  def cancellation
  end

  def index
    @q = Boarding.where(status: -1).search(params[:q])
    @boardings = Boarding.the_day
  end

  def search
    @q = Boarding.joins(:driver).order(date_boarding: :desc, id: :desc).search(params[:query])
    @boardings = @q.result
    respond_with(@boardings) do |format|
      format.js
    end
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
    @boarding = Boarding.generate_shipping(params[:os][:ids]) #deve retornar o id
    if @boarding.errors.present?
      @boarding.errors.full_messages.each do |msg|
        flash[:danger] = msg
      end
      redirect_to boardings_path
    else
      respond_to do |format|
        format.html { redirect_to @boarding, flash: { success: "Boarding was successfully created." } }
        format.json { render action: 'show', status: :created, location: @boarding }
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

  def oper
    @boardings = Boarding.the_day
    #@boardings = Boarding.status_open
  end

  def sup
    @boardings = Boarding.the_day
    #@boardings = Boarding.status_open
  end

  def confirmed

  end

  def update_confirmed
    if @boarding.status == Boarding::TipoStatus::EMBARCADO
      flash[:danger] = "Embarque já foi confirmado."
      redirect_to dashboard_oper_path
      return
    end
    if params[:boarding][:qtde_pallets_shipped].blank?
      flash[:danger] = "Informar qtde pallets."
      redirect_to dashboard_oper_path
      return
    end
    @boarding.confirmed_user_id = current_user.id
    @boarding.update(boarding_params)
    Boarding.confirmed(params[:id])
    redirect_to dashboard_oper_path, flash: { success: "Boarding confirmed was successful" }
  end

  def start
    if @boarding.pending?
      flash[:danger] = @boarding.pending
      redirect_to oper_boardings_path
    end
  end

  def update_start
    if !@boarding.boarding_vehicles.present?
      flash[:danger] = "Vehicle is not present."
      redirect_to dashboard_oper_path
      return
    elsif params[:boarding][:place].blank?
      flash[:danger] = "Place is not present."
      redirect_to dashboard_oper_path
      return
    elsif params[:boarding][:team].blank?
      flash[:danger] = "Team is not present."
      redirect_to dashboard_oper_path
      return
    elsif params[:boarding][:hangar].blank?
      flash[:danger] = "Hangar is not present."
      redirect_to dashboard_oper_path
      return
    elsif params[:boarding][:dock].blank?
      flash[:danger] = "Dock is not present."
      redirect_to dashboard_oper_path
      return
    elsif !@boarding.places.include?(params[:boarding][:place].upcase)
      flash[:danger] = "Place is not present on boarding."
      redirect_to dashboard_oper_path
      return
    end
    @boarding.started_user_id = current_user.id
    @boarding.update(boarding_params)
    Boarding.start(params[:id])
    redirect_to dashboard_oper_path, flash: { success: "Boarding initialization was successful" }
  end

  def checkin

  end

  def update_checkin
    if params[:boarding][:driver_checkin_palce_horse].blank?
      flash[:danger] = "Place is not present."
      redirect_to dashboard_oper_path
      return
    elsif params[:boarding][:driver_checkin_palce_cart_1].blank?
      flash[:danger] = "Place Cart 1  is not present."
      redirect_to dashboard_oper_path
      return
    # elsif params[:boarding][:driver_checkin_palce_cart_2].blank?
    #   flash[:danger] = "Place Cart 2 is not present."
    #   redirect_to dashboard_oper_path
    #   return
    end

    @boarding.driver_checkin_user_id = current_user.id
    @boarding.update(boarding_params)
    Boarding.checkin(params[:id])
    redirect_to dashboard_port_path, flash: { success: "Boarding Check IN was successful" }
  end

  def detail; end


	def destroy
    @boarding.destroy
    respond_to do |format|
      format.html { redirect_to boardings_url }
      format.json { head :no_content }
    end
  end

  def letter_freight
    if @boarding.date_boarding.nil?
      flash[:danger] = "Date Boarding is not present."
      redirect_to boarding_path(@boarding)
      return
    elsif !@boarding.vehicle_tracao.present?
      flash[:danger] = "Vehicle Traction is not present.."
      redirect_to boarding_path(@boarding)
      return
    elsif !@boarding.vehicle_tracao.owners.present?
      flash[:danger] = "Vehicle Traction is not present does not have an owner."
      redirect_to boarding_path(@boarding)
      return
    end

    respond_to do |format|
      format.html
      format.pdf { render_letter_freight(@boarding) }
    end

  end

  def print
    if @boarding.date_boarding.blank?
      flash[:danger] = "Date of shipment not informed."
      redirect_to boarding_path(@boarding)
      return
    elsif @boarding.driver_id == Boarding.driver_not_information
      flash[:danger] = "Inform o driver."
      redirect_to boarding_path(@boarding)
      return
    elsif @boarding.carrier == Boarding.carrier_not_information
      flash[:danger] = "Inform o carrier."
      redirect_to boarding_path(@boarding)
      return
    elsif @boarding.value_boarding.nil? || @boarding.value_boarding.to_f == 0.00
      flash[:danger] = "Enter the value of the freight."
      redirect_to boarding_path(@boarding)
      return
    elsif !@boarding.boarding_vehicles.present?
      flash[:danger] = "Report vehicles for shipping."
      redirect_to boarding_path(@boarding)
      return

    end

    respond_to do |format|
      format.html
      format.pdf { render_print_boarding(@boarding) }
    end
  end

  def comments
    @comment = Comment.new
  end

  def request_pallet

  end

  def requisition
    if params[:qtde].blank?
      flash[:danger] = "Inform the quantity of equipament."
      redirect_to request_pallet_boarding_path(@boarding)
      return
    end
    if params[:equipament].blank?
      flash[:danger] = "Inform the quantity of equipament."
      redirect_to request_pallet_boarding_path(@boarding)
      return
    end
    if @boarding.requisition?({qtde: params[:qtde], driver: params[:driver_id], equipament: params[:equipament]})
      flash[:success] = "Successful request of equipament."
    else
      flash[:danger] = "An error occurred while ordering the equipament."
    end
    redirect_to boarding_path(@boarding)
  end

	private

		def set_boarding
			@boarding = Boarding.find(params[:id])
      @boarding_items = @boarding.boarding_items.order(:row_order) if @boarding.boarding_items.present?
      @boarding_item = BoardingItem.new
		end

    def boarding_params
      params.require(:boarding).permit(:ids, :os, :date_boarding, :driver_id, :carrier_id, :value_boarding, :safe_rctr_c,
        :safe_optional, :number_tranking, :obs, :qtde_boarding, :manifesto, :chave_manifesto, :local_embarque,
        :action_inspector, :place, :qtde_pallets_shipped, :team, :hangar, :dock, :oper_observation,
        :driver_checkin_palce_horse, :driver_checkin_palce_cart_1, :driver_checkin_palce_cart_2, :sealing, :sealing_two, :sealing_three,
        board_items_attributes: [:delivery_number, :ordem_service_id, :id, :_destroy],
        boarding_vehicles_attributes: [:boarding_vehicles_id, :vehicle_id, :id, :_destroy]

      	)
    end

    def render_letter_freight(boarding)
      report = Thinreports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'carta_frete.tlf')
      report.start_new_page

      # cabecalho empresa
      @company = Company.first
      report.page.item(:image_logo).src(@company.image.path) #@company.image.url
      report.page.item(:emp_fantasia).value(@company.fantasia)
      report.page.item(:emp_razao_social).value(@company.razao_social)
      report.page.item(:emp_cnpj).value("CNPJ: " + @company.cnpj)
      report.page.item(:emp_fone).value("CONTATO: " + @company.phone_first)
      report.page.item(:emp_cidade).value(@company.cidade_estado)

      emitido = "EMITIDO EM: #{date_br(Date.current)} as #{time_br(Time.current)} por #{current_user.email} - IP. #{current_user.current_sign_in_ip}"
      owner = @boarding.vehicle_tracao.owners.first
      local_data = "FORTALEZA, #{l boarding.date_boarding , format: :long }"

      report.page.item(:no_contrato).value(boarding.id)
      report.page.item(:valor_frete).value(boarding.value_boarding)
      report.page.item(:valor_pedagio).value("")
      report.page.item(:valor_adiantamento).value("")
      report.page.item(:valor_saldo).value("")
      report.page.item(:no_manifesto).value("000000")
      report.page.item(:data_expedicao).value(local_data)

      report.page.item(:owner_name).value(owner.nome)
      report.page.item(:owner_cpf).value(owner.cpf_cnpj)
      report.page.item(:owner_address).value(owner.endereco + ',' + owner.numero)
      report.page.item(:owner_complement).value(owner.complemento)
      report.page.item(:owner_district_city).value(owner.distric_city_state_cep)

      report.page.item(:tracao_marca).value("MARCA: #{@boarding.vehicle_tracao.marca}")
      report.page.item(:tracao_renavan).value("RENAVAN: #{@boarding.vehicle_tracao.renavan}")
      report.page.item(:tracao_chassi).value("CHASSI: #{@boarding.vehicle_tracao.chassi}")
      report.page.item(:tracao_placa).value("PLACA: #{@boarding.vehicle_tracao.placa}")

      if @boarding.vehicle_reboque.present?
        report.page.item(:reboque_marca).value("MARCA: #{@boarding.vehicle_reboque.marca}")
        report.page.item(:reboque_renavan).value("RENAVAN: #{@boarding.vehicle_reboque.renavan}")
        report.page.item(:reboque_chassi).value("CHASSI: #{@boarding.vehicle_reboque.chassi}")
        report.page.item(:reboque_placa).value("PLACA: #{@boarding.vehicle_reboque.placa}")
      end

      report.page.item(:driver_name).value(boarding.driver.nome)
      report.page.item(:driver_cpf).value(boarding.driver.cpf)
      report.page.item(:driver_address).value(boarding.driver.endereco + ',' + boarding.driver.numero)
      report.page.item(:driver_complement).value(boarding.driver.complemento)
      report.page.item(:driver_district_city).value(boarding.driver.distric_city_state_cep)
      report.page.item(:data_and_hora).value(emitido)

      send_data report.generate, filename: "letter_freight_#{boarding.id}_.pdf",
                                   type: 'application/pdf',
                                   disposition: 'inline'
    end

    def render_print_boarding(boarding)
      report = Thinreports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'embarque.tlf')
      # valor = (quitter.total_pago.to_f * 100).to_i
      # local_data = "FORTALEZA, #{l Date.today , format: :long }"
      report.start_new_page

      emitido = "EMITIDO EM: #{date_br(Date.current)} as #{time_br(Time.current)} por #{current_user.email} - IP. #{current_user.current_sign_in_ip}"

      # cabecalho empresa
      @company = Company.first
      report.page.item(:image_logo).src(@company.image.path) #@company.image.url
      report.page.item(:emp_fantasia).value(@company.fantasia)
      report.page.item(:emp_razao_social).value(@company.razao_social)
      report.page.item(:emp_cnpj).value("CNPJ: " + @company.cnpj)
      report.page.item(:emp_fone).value("CONTATO: " + @company.phone_first)
      report.page.item(:emp_cidade).value(@company.cidade_estado)

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

          row.values(os: item.ordem_service.id)
          row.values(data: date_br(item.ordem_service.data))
          row.values(cliente: item.ordem_service.client.nome)
          row.values(cidade: item.ordem_service.client.cidade + '-' + item.ordem_service.client.estado)
          row.values(peso: "#{number_to_currency(item.ordem_service.peso, precision: 3, unit: "", separator: ",", delimiter: ".")}")
          row.values(volume: "#{number_to_currency(item.ordem_service.qtde_volume, precision: 3, unit: "", separator: ",", delimiter: ".")}")
          row.values(ctes: item.ordem_service.get_number_cte)
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

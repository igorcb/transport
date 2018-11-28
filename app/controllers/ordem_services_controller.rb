#encoding: utf-8
class OrdemServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ordem_service, only: [:show, :edit, :update, :destroy, :close_os, :request_payment]
  #before_action :is_not_edit, only: [:edit, :update ]
  load_and_authorize_resource
  respond_to :html, :js, :json

  def index
    tipo = 1
    if current_user.has_role? :admin
      @q = OrdemService.joins(:ordem_service_logistics).order('id desc').search(params[:q])
      @ordem_services = @q.result.paginate(:page => params[:page])
    else
      @q = OrdemService.where(carrier_id: current_user.carrier_id).order('id desc').search(params[:q])
      @ordem_services = @q.result.paginate(:page => params[:page])
    end
  end

  def show
    @account_payable = AccountPayable.new
    @account_receivable = AccountReceivable.new
    @ordem_service_type_service = OrdemServiceTypeService.new

    if current_user.has_role? :admin
      @comment = @ordem_service.comments.build
      @internal_comment = @ordem_service.internal_comments.build
      @cancellation = @ordem_service.cancellations.build
      respond_to do |format|
        format.html { ordem_service_path(@ordem_service) }
        #redirect_to show_agent_ordem_service_path(@ordem_service.id)
      end
      #respond_with(@ordem_service)
    else
      redirect_to show_agent_ordem_service_path(@ordem_service)
    end
  end

  def new
  end

  def edit
     # if @ordem_service.status == OrdemService::TipoStatus::FECHADO
     #   flash[:danger] = "Ordem Service already is closed."
     #    redirect_to @ordem_service
     #  else
     #    redirect_to show_agent_ordem_service_path(@ordem_service)
     #  end
     #  return
     # end
    # if current_user.has_role? :agent
    #   if @ordem_service.status == OrdemService::TipoStatus::FECHADO
    #     flash[:danger] = "Ordem Service already is closed."
    #     redirect_to show_agent_ordem_service_path(@ordem_service)
    #     return
    #   end
    # end
    @type_os = @ordem_service.tipo
  end

  def edit_agent
    if @ordem_service.status == OrdemService::TipoStatus::FECHADO
      flash[:danger] = "Ordem Service already is closed."
      redirect_to show_agent_ordem_service_path(@ordem_service)
      return
    end
  end

  def create
    source_client  = Client.find_by_cpf_cnpj(params[:source_client_cpf_cpnj])
    target_client  = Client.find_by_cpf_cnpj(params[:target_client_cpf_cpnj])
    if params[:ordem_service][:tipo].to_i == OrdemService::TipoOS::MUDANCA
      #puts ">>>>>>>>>>>>>>>>>>>> Tipo OS: #{params[:ordem_service][:tipo].to_i}"
      billing_client = Client.find_by_cpf_cnpj(params[:billing_client_cpf_cnpj])
    else
      #puts ">>>>>>>>>>>>>>>>>>>> Tipo OS: #{params[:ordem_service][:tipo].to_i}"
      billing_client = Client.find(params[:ordem_service][:billing_client_id])
    end
    @ordem_service = OrdemService.new(ordem_service_params)
    @ordem_service.source_client_id = source_client.id if source_client.present?
    @ordem_service.target_client_id = target_client.id if target_client.present?
    @ordem_service.estado = target_client.estado if target_client.present?
    @ordem_service.cidade = target_client.cidade if target_client.present?
    @ordem_service.billing_client_id = billing_client.id

    respond_to do |format|
      if @ordem_service.save
        format.html { redirect_to @ordem_service, flash: { success: "Ordem Service was successfully created." } }
        format.json { render action: 'show', status: :created, location: @ordem_service }
      else
        #format.html { render action: 'new' }
        # format.json { render json: @ordem_service.errors, status: :unprocessable_entity }
        format.html do
          case params[:ordem_service][:tipo].to_i
            when 1 then render partial: 'form_logistic', change: 'form_ordem_service'
            when 3 then render partial: 'form_change', change: 'form_ordem_service'
            when 4 then render partial: 'form_air', change: 'form_ordem_service'
          end
        end
      end
    end
  end

  # def create
  #   client = Client.find_by_cpf_cnpj(params[:client_cpf_cpnj])
  #   tipo = params[:tipo]
  #   @ordem_service = OrdemService.new(ordem_service_params)
  #   @ordem_service.client_id = client.id if client.present?
  #   @ordem_service.estado = client.estado if client.present?
  #   @ordem_service.cidade = client.cidade if client.present?
  #   respond_to do |format|
  #     if @ordem_service.save
  #       format.html { redirect_to @ordem_service, flash: { success: "Ordem Service was successfully created." } }
  #       format.json { render action: 'show', status: :created, location: @ordem_service }
  #     else
  #       puts ">>>>>>> No saved!!!"
  #       case tipo.to_i
  #         when 1 then format.html { render partial: 'form_logistic', change: 'form_ordem_service' }
  #         when 2 then format.html { render partial: 'form_air', change: 'form_ordem_service' }
  #       end
  #       format.json { render json: @ordem_service.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def update
    respond_to do |format|
      if @ordem_service.update(ordem_service_params)
        format.html { redirect_to @ordem_service, flash: { success: "Ordem Service was successfully updated." } }
        format.json { head :no_content }
      else
        format.html do
          case params[:ordem_service][:tipo].to_i
            when 1 then render partial: 'form_logistic', change: 'form_ordem_service'
            when 3 then render partial: 'form_change', change: 'form_ordem_service'
            when 4 then render partial: 'form_air', change: 'form_ordem_service'
          end
        end
        format.json { render json: @ordem_service.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_agent
    ActiveRecord::Base.transaction do
      respond_to do |format|
        if @ordem_service.update(ordem_service_params)
          qtde = params[:pallet][:qtde]
          valor = qtde.to_f * Pallet::TypeService::VALOR_COBRADO_PALLETE
          os_type_service = OrdemServiceTypeService.find_by(ordem_service_id: @ordem_service.id, type_service_id: Pallet::TypeService::PALLET)
          Pallet.update(@ordem_service.pallet, status: Pallet::TipoStatus::OS_CRIADA, qtde: qtde, data_agendamento: params[:ordem_service][:data])
          OrdemServiceTypeService.update(os_type_service, qtde: qtde, valor: valor)
          format.html { redirect_to show_agent_ordem_service_path(@ordem_service.id), flash: { success: "Ordem Service was successfully updated." } }
          format.json { head :no_content }
        else
          format.html { render action: 'edit_agent' }
          format.json { render json: @ordem_service.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def cancel
    if @ordem_service.status == OrdemService::TipoStatus::ENTREGA_EFETUADA
      flash[:danger] = "You can not cancel the ordem service done delivery."
      redirect_to ordem_service_path(@ordem_service)
    elsif @ordem_service.status == OrdemService::TipoStatus::FECHADO
      flash[:danger] = "You can not cancel the ordem service taken closed."
      redirect_to ordem_service_path(@ordem_service)
    elsif @ordem_service.status == OrdemService::TipoStatus::FATURADO
      flash[:danger] = "You can not cancel the ordem service taken billing."
      redirect_to ordem_service_path(@ordem_service)
    elsif @ordem_service.status == OrdemService::TipoStatus::NAO_FATURAR
      flash[:danger] = "You can not cancel the ordem service taken invoice."
      redirect_to ordem_service_path(@ordem_service)
    elsif @ordem_service.status == OrdemService::TipoStatus::PAGA
      flash[:danger] = "You can not cancel the ordem service pay."
      redirect_to ordem_service_path(@ordem_service)
    elsif @ordem_service.status == OrdemService::TipoStatus::SOLICITACAO_CANCELAMENTO
      flash[:danger] = "You can not cancel the ordem service request cancellation."
      redirect_to ordem_service_path(@ordem_service)
    elsif @ordem_service.status == OrdemService::TipoStatus::CANCELADA
      flash[:danger] = "You can not cancel the ordem service cancellation."
      redirect_to ordem_service_path(@ordem_service)
    elsif @ordem_service.status > 7
      flash[:danger] = "You can not cancel the ordem service status more than 6 (not defined)."
      redirect_to ordem_service_path(@ordem_service)
    end
    @ordem_service.cancellations.build
  end

  def update_cancel
    if params[:ordem_services][:observacao].length < 15
      flash[:danger] = "Observacao is too short (minimum is 15 characters)."
      redirect_to ordem_service_path(@ordem_service)
      return
    end

    OrdemService.cancel(current_user.id, params[:ordem_services])
    redirect_to ordem_service_path(params[:id]), flash: { success: "Request for cancellation of Ordem Service was successful." }
  end

  def destroy
    @ordem_service.destroy
    respond_with(@ordem_service)
  end

  def type_new_ordem_service
    @type_os = params[:tipo_os].to_i
    @ordem_service = OrdemService.new
    @ordem_service.ordem_service_logistics.build
    @ordem_service.ordem_service_changes.build
    @ordem_service.ordem_service_airs.build
    @ordem_service.cte_keys.build
    @ordem_service.nfe_keys.build
    @ordem_service.ordem_service_type_service.build #if @type_os == OrdemService::TipoOS::LOGISTICA

    respond_to do |format|
      format.js
    end
  end

  def calculate_freight
    @client = Client.find_by_cpf_cnpj(params[:cpf_cpnj])
    @peso_os = params[:os_peso]
    @volume_os = params[:os_volume]
    respond_to do |format|
     format.js
    end
  end

  def type_ordem_service
    @tipo_os = params[:type].to_i
    case @tipo_os
    when 1 then  @ordem_services = OrdemService.joins(:client, :ordem_service_logistics).where(tipo: @tipo_os).paginate(:page => params[:page]).order(id: :desc)
    when 3 then  @ordem_services = OrdemService.joins(:client, :ordem_service_changes).where(tipo: @tipo_os).paginate(:page => params[:page]).order(id: :desc)
    when 4 then  @ordem_services = OrdemService.joins(:client, :ordem_service_airs).where(tipo: @tipo_os).paginate(:page => params[:page]).order(id: :desc)
    end
    respond_with(@ordem_services) do |format|
      format.html { render :layout => !request.xhr? }
    end
  end

  def search
    if current_user.has_role? :admin
      @q = OrdemService.paginate(:page => params[:page]).search(params[:q])
    else
      @q = OrdemService.where(carrier_id: current_user.carrier_id).paginate(:page => params[:page]).search(params[:q])
    end
    respond_with(@ordem_services) do |format|
      format.html { render :layout => !request.xhr? }
    end
  end

  def search_type_ordem_service
    @tipo_os = params[:type].to_i
    @q = OrdemService.where(status: -1).joins(:ordem_service_logistics).search(params[:q])
    @ordem_services = @q.result
    respond_with(@ordem_services) do |format|
     format.html { render :layout => !request.xhr? }
    end
  end

  def search_logistic
    @q = OrdemService.joins(:ordem_service_logistics).order(id: :desc).paginate(:page => params[:page]).search(params[:query])
    @ordem_services = @q.result
    respond_with(@ordem_services) do |format|
      format.js
    end
  end

  def delivery
    if @ordem_service.status == OrdemService::TipoStatus::ABERTO
      flash[:danger] = "Ordem Service is already as ABERTO."
      redirect_to ordem_service_path(@ordem_service)
      return
    elsif @ordem_service.status == OrdemService::TipoStatus::AGUARDANDO_EMBARQUE
      flash[:danger] = "Ordem Service is already as WAITING FOR BOARDING."
      redirect_to ordem_service_path(@ordem_service)
      return
    elsif @ordem_service.status == OrdemService::TipoStatus::ENTREGA_EFETUADA
      flash[:danger] = "Ordem Service is already as delivered."
      redirect_to ordem_service_path(@ordem_service)
      return
    # elsif !@ordem_service.boarding.check_status_ordem_service_embarcado?
    #   flash[:danger] = "To close a ordem service, all ordem services in boarding, must be as boarding."
    #   redirect_to ordem_service_path(@ordem_service)
    #   return
    elsif @ordem_service.status == OrdemService::TipoStatus::FECHADO
      flash[:danger] = "Ordem Service is already as closed."
      redirect_to ordem_service_path(@ordem_service)
      return
    elsif @ordem_service.status == OrdemService::TipoStatus::FATURADO
      flash[:danger] = "Ordem Service is already as BILLING."
      redirect_to ordem_service_path(@ordem_service)
      return
    elsif !@ordem_service.ordem_service_type_service.present?
      flash[:danger] = "Can not close without an Type Ordem Service associated service."
      redirect_to ordem_service_path(@ordem_service)
      return
    elsif !@ordem_service.data.present?
      flash[:danger] = "Data Agendamento can't be blank."
      redirect_to ordem_service_path(@ordem_service)
      return
    elsif !@ordem_service.billing_client_id.present?
      flash[:danger] = "Client billing can't be blank."
      redirect_to ordem_service_path(@ordem_service)
      return
    elsif !@ordem_service.billing_client_id.present?
      flash[:danger] = "Client billing can't be blank."
      redirect_to ordem_service_path(@ordem_service)
      return
    elsif !@ordem_service.send_email?
      flash[:danger] = "Please defined email to delivery."
      redirect_to ordem_service_path(@ordem_service)
      return
    elsif !@ordem_service.ordem_service_logistic.delivery_driver_id.present?
      flash[:danger] = "Driver to delivery can't be blank."
      redirect_to ordem_service_path(@ordem_service)
      return
    end

  end

  def update_delivery
    #byebug
    if params[:ordem_service][:data_entrega_servico].blank?
      flash[:danger] = "Data Entrega Servico can't be blank."
      redirect_to ordem_service_path(@ordem_service)
      return
    elsif params[:ordem_service][:data_entrega_servico].to_date < @ordem_service.boarding.date_boarding
      flash[:danger] = "Delivery date of service can not be less than the date of shipment"
      redirect_to ordem_service_path(@ordem_service)
      return
    end
    if @ordem_service.update(ordem_service_params)
      #OrdemService.information_delivery(current_user, params[:id])
      result = OrdemServices::UpdateDeliveryService.new(@ordem_service, current_user).call
      respond_to do |format|
        format.html { redirect_to @ordem_service, flash: { success: "Ordem Service delivery was successful. \n #{result}" } }
      end
    else
       redirect_to @ordem_service, flash: { danger: "Erro ao entregar a ordem de servico. \n #{result}" }
    end
    # respond_to do |format|
    #   if @ordem_service.update(ordem_service_params)
    #     OrdemService.information_delivery(current_user, params[:id])
    #     format.html { redirect_to @ordem_service, flash: { success: "Ordem Service delivery was successful." } }
    #     #redirect_to ordem_service_path(@ordem_service)
    #     #format.json { head :no_content }
    #   end
    # end
  end

  def close
    puts ">>>>>>>>>>>>>>>>>>>>>>> Close: #{@ordem_service.check_left_handed?}"
    if !@ordem_service.check_left_handed?
      flash[:danger] = "Informe todos os canhotos da nf-e"
      redirect_to left_handed_ordem_service_path(@ordem_service)
      return
    end

    if params[:ordem_service].present?
      respond_to do |format|
        #if @ordem_service.update(ordem_service_params) && OrdemService.close_os(params[:id])
        if @ordem_service.update(ordem_service_params) && @ordem_service.close_os
          format.html { redirect_to @ordem_service, flash: { success: "Ordem Service closed was successful ****." } }
          format.json { head :no_content }
        else
          format.html { render action: 'close_os' }
          format.json { render json: @ordem_service.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        #if @ordem_service.update(ordem_service_params) && OrdemService.close_os(params[:id])
        if @ordem_service.close_ordem_service
          format.html { redirect_to @ordem_service, flash: { success: "Ordem Service closed was successful &&&&." } }
          format.json { head :no_content }
        else
          puts "Ordem de Servico com problemas"
          format.html { render action: 'edit' }
          format.json { render json: @ordem_service.errors, status: :unprocessable_entity }
        end
      end

    end
  end

  def close_os
    puts "Tipo OS: #{@ordem_service.tipo}"
    case @ordem_service.tipo
      when OrdemService::TipoOS::LOGISTICA
        if @ordem_service.status == OrdemService::TipoStatus::FECHADO
          flash[:danger] = "Ordem Service is already as closed."
          redirect_to ordem_service_path(@ordem_service)
          return
        elsif @ordem_service.status == OrdemService::TipoStatus::ABERTO
          flash[:danger] = "Ordem Service is open, make the shipment."
          redirect_to ordem_service_path(@ordem_service)
          return
        elsif @ordem_service.status == OrdemService::TipoStatus::AGUARDANDO_EMBARQUE
          flash[:danger] = "Please do the shipment of the order of service."
          redirect_to ordem_service_path(@ordem_service)
          return
        elsif @ordem_service.status == OrdemService::TipoStatus::EMBARCADO
          flash[:danger] = "You can not close a service order without it being delivered."
          redirect_to ordem_service_path(@ordem_service)
          return
        elsif !@ordem_service.ordem_service_type_service.present?
          flash[:danger] = "Can not close without an Order of Service associated service."
          redirect_to ordem_service_path(@ordem_service)
          return
        elsif !@ordem_service.data.present?
          flash[:danger] = "Data Agendamento can't be blank."
          redirect_to ordem_service_path(@ordem_service)
          return
        elsif !@ordem_service.data_entrega_servico.present?
          flash[:danger] = "Data Entrega Servico can't be blank."
          redirect_to ordem_service_path(@ordem_service)
          return
        elsif !@ordem_service.billing_client_id.present?
          flash[:danger] = "Client billing can't be blank."
          redirect_to ordem_service_path(@ordem_service)
          return
        end
      when OrdemService::TipoOS::MUDANCA
        puts ">>>>>>>>>>>> CloseOs Mudanca."
        @ordem_service.close_ordem_service
        redirect_to @ordem_service, flash: { success: "Ordem Service closed was successful..." }
      when OrdemService::TipoOS::AEREO
        @ordem_service.close_ordem_service
        redirect_to @ordem_service, flash: { success: "Ordem Service closed was successful......" }
    end
    #OrdemService.close_os(params[:id])
    #redirect_to @ordem_service, flash: { success: "Ordem Service closed was successful..............." }
  end

  def left_handed

  end

  def update_left_handed
    respond_to do |format|
      if @ordem_service.update(ordem_service_params)
        format.html { redirect_to @ordem_service, flash: { success: "Ordem Service left_handed was successful." } }
        format.json { head :no_content }
      else
        format.html { render action: 'left_handed' }
        format.json { render json: @ordem_service.errors, status: :unprocessable_entity }
      end
    end
  end

  def faturamento
    @type_services = TypeService.logistica
    @ordem_service = OrdemService.new
    @ordem_services = OrdemService.where(status: OrdemService::TipoStatus::FECHADO).order(:id)
    respond_with(@ordem_services)
  end

  def ordem_service_to_type_service
    @type_service = TypeService.find(params[:id])
    @ordem_services = OrdemServiceTypeService.joins(:ordem_service)
                                             .where(type_service: @type_service,
                                                    ordem_services: { status: OrdemService::TipoStatus::FECHADO } )
                                             .order('ordem_services.data')
    respond_with(@ordem_services) do |format|
      format.html { render :layout => !request.xhr? }
    end
  end

  def invoice
    ids = OrdemService.get_hash_ids(params[:os][:ids])
    puts ">>>>>>>>>>>>>>>>>>>>>>> check_client_billing: #{OrdemService.check_client_billing?(ids)} <<<<<<<<<<<<<<<<<<<<<<<<"
    if !OrdemService.check_client_billing?(ids)
      flash[:danger] = "Customer invoices are not the same."
      redirect_to faturamento_path
      return
    end
    OrdemService.invoice(params[:os][:ids], params[:id_service], params[:valor_total])
    redirect_to billings_path
  end

  def request_payment
    if !@ordem_service.boarding.present?
      flash[:danger] = "There is not boarding associated with this ordem service."
      redirect_to ordem_service_path(@ordem_service)
      return
    elsif @ordem_service.ordem_service_logistic.delivery_driver_id.nil?
      flash[:danger] = "Select a driver to request payment."
      redirect_to ordem_service_path(@ordem_service)
      return
    elsif @ordem_service.ordem_service_logistic.delivery_driver_id == Driver::STANDARD
      flash[:danger] = "Select a driver to request payment."
      redirect_to ordem_service_path(@ordem_service)
      return
    end

    hash = eval(params[:discharges])

    @account_payable = @ordem_service.account_payables.build
    @account_payable.type_account = AccountPayable::TypeAccount::DRIVER
    @account_payable.supplier_type = "Driver"
    @account_payable.supplier_id = @ordem_service.ordem_service_logistic.delivery_driver_id
    @account_payable.cost_center_id = ConfigSystem.where(config_key: 'PAYMENT_DISCHARGE_COST_CENTER').first.config_value
    @account_payable.sub_cost_center_id = ConfigSystem.where(config_key: 'PAYMENT_DISCHARGE_SUB_COST_CENTER').first.config_value
    @account_payable.sub_cost_center_three_id = ConfigSystem.where(config_key: 'PAYMENT_DISCHARGE_SUB_COST_CENTER_THREE').first.config_value
    @account_payable.payment_method_id = ConfigSystem.where(config_key: 'PAYMENT_METHOD_DEFAULT').first.config_value
    @account_payable.historic_id = ConfigSystem.where(config_key: 'HISTORIC_DEFAULT').first.config_value
    @account_payable.data_vencimento = Date.today
    @account_payable.documento = "#{@ordem_service.id}/#{@ordem_service.boarding.id}"
    @account_payable.valor = hash[:value_discharge]
    @account_payable.observacao = "PAGAMENTO DE DESCARGA O.S No: #{@ordem_service.id}, NF-e: #{@ordem_service.get_number_nfe}"
    @account_payable.status = AccountPayable::TipoStatus::ABERTO
    @account_payable.save
    respond_with(@ordem_service)
    # else
    #   @ordem_service.errors.full_messages.each do |msg|
    #     flash.now[:error] = msg
    #   end
      #respond_with(@ordem_service)
      #format.json { render json: @ordem_service.errors, status: :unprocessable_entity }
      # @ordem_service.errors.full_messages.each do |msg|
      #   flash[:error] = msg
      #   respond_with(@ordem_services) do |format|
      #     format.html { render :layout => !request.xhr?  }
      #   end
      #   #respond_with(@ordem_service)
      # end
    #end
  end

  def index_agent
    #@q = OrdemService.order('id desc').search(params[:q])
    carrier = current_user.carrier_id.nil? ? -1 : current_user.carrier_id
    @ordem_services = OrdemService.where(carrier_id: carrier, status: OrdemService::TipoStatus::ABERTO).order('id desc')
  end

  def pallet
    @ordem_services = OrdemService.where(id: params[:id])
    respond_with(@ordem_service)
  end

  def show_agent
    #@ordem_services = OrdemService.where(id: params[:id], carrier_id: current_user.carrier_id)
    @ordem_services = OrdemService.where(id: params[:id])
    respond_with(@ordem_service)
  end

  def ordem_service_comments #Client
    @ordem_service = OrdemService.where(id: params[:id]).first
  end

  def request_payables
    @ordem_service_type_service = OrdemServiceTypeService.status_open
  end

  def create_payables
    OrdemService.create_payables(params[:id], params[:item_id])
    redirect_to request_payables_ordem_services_path
  end

  def billing_group_places
    #@ordem_services = OrdemService.is_not_billed
    @ordem_services = OrdemService.group_by
  end

  def tag

  end

  def list_ordem_service_scheduling
    log_in = 9
    @ordem_services = OrdemService.includes(:billing, :input_control, :ordem_service_type_service).order("input_controls.date_entry").search(billing_client_group_client_id_eq: log_in).result
    #where(billing_client_id: 468).order("ordem_services.id desc").limit(300)
  end

  private
    def set_ordem_service
      @ordem_service = OrdemService.find(params[:id])
    end

    def is_not_edit
      @ordem_service = OrdemService.find(params[:id])
      if @ordem_service.status == OrdemService::TipoStatus::FATURADO
        flash[:danger] = "Ordem Service already is billing."
        redirect_to ordem_service_path(@ordem_service)
        return
      end
    end

    def ordem_service_params
      params.require(:ordem_service).permit(:billing_client_id, :client_table_price_id, :data, :estado, :cidade, :valor_receita, :valor_despesas, :valor_liquido,
        :observacao, :status, :hora_agendamento, :data_entrega_servico, :carrier_id, :tipo, :date_shipping, :date_entry, :date_otif, :lead_time,

        ordem_service_airs_attributes: [:source_stretch_id, :target_stretch_id, :solicitante, :target_agent_id, :airline_carrier_id,
          :qtde_volume, :peso, :valor_nf, :total_cubagem, :tarifa_companhia, :tipo_frete, :valor_total, :awb, :voo, :id, :_destroy],

        ordem_service_logistics_attributes: [:driver_id, :delivery_driver_id, :placa, :cte, :danfe_cte,:qtde_volume, :peso, :senha_sefaz, :qtde_palets, :id, :_destroy],
        ordem_service_changes_attributes: [
          :source_cep,:source_numero,:source_complemento,:source_endereco_completo,:source_endereco,:source_bairro,:source_cidade,:source_estado,:source_contato,
          :target_cep,:target_numero,:target_complemento,:target_endereco_completo,:target_endereco,:target_bairro,:target_cidade,:target_estado,:target_contato,
          :driver_id, :placa,:driver,:compartilhado,:cubagem,:valor_declarado, :valor_total, :dias, :id, :_destroy],
        cancellations_attributes: [:solicitation_user_id, :authorization_user_id, :status, :observacao, :id, :_destroy],
        cte_keys_attributes: [:cte, :chave, :asset, :id, :_destroy],
        nfe_keys_attributes: [:nfe, :chave, :asset, :qtde, :remessa_ype, :peso, :volume, :retained, :id, :_destroy],
        nfs_keys_attributes: [:nfs, :chave, :id, :_destroy],
        ordem_service_type_service_attributes: [:ordem_service_id, :type_service_id, :valor, :qtde, :qtde_recebida, :valor_pago, :advance_money_number, :id, :_destroy],
        account_banks_attributes: [:banco, :nome_banco, :tipo_operacao, :agencia, :conta_corrente, :favorecido, :cpf_cnpj, :valor, :id, :_destroy],
        assets_attributes: [:asset, :user_id, :id, :_destroy]

        )
    end
end

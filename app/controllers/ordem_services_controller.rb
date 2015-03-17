class OrdemServicesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_ordem_service, only: [:show, :edit, :update, :destroy, :close_os ]
  load_and_authorize_resource
  respond_to :html

  def index
    if current_user.has_role? :admin
      @q = OrdemService.order('id desc').search(params[:q])
      @ordem_services = @q.result
    else
      @q = OrdemService.where(carrier_id: current_user.carrier_id).order('id desc').search(params[:q])
      @ordem_services = @q.result
    end
  end

  def show
    @account_payable = AccountPayable.new
    
    if current_user.has_role? :admin
      @comment = @ordem_service.comments.build
      @internal_comment = @ordem_service.internal_comments.build
      respond_with(@ordem_service)
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
    client = Client.find_by_cpf_cnpj(params[:client_cpf_cpnj])
    @ordem_service = OrdemService.new(ordem_service_params)
    @ordem_service.client_id = client.id if client.present?
    @ordem_service.estado = client.estado if client.present?
    @ordem_service.cidade = client.cidade if client.present?

    respond_to do |format|
      if @ordem_service.save 
        format.html { redirect_to @ordem_service, flash: { success: "Ordem Service was successfully created." } }
        format.json { render action: 'show', status: :created, location: @ordem_service }
      else
        #format.html { render action: 'new' }
        format.html do
          case params[:ordem_service][:tipo].to_i
            when 1 then render partial: 'form_logistic', change: 'form_ordem_service'
            when 4 then render partial: 'form_air', change: 'form_ordem_service'
          end
        end
        format.json { render json: @ordem_service.errors, status: :unprocessable_entity }
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

  def destroy
    @ordem_service.destroy
    respond_with(@ordem_service)
  end
  
  def type_new_ordem_service  
    @type_os = params[:tipo_os].to_i
    @ordem_service = OrdemService.new
    @ordem_service.ordem_service_airs.build
    @ordem_service.ordem_service_logistics.build
    @ordem_service.cte_keys.build
    @ordem_service.nfe_keys.build

    respond_to do |format|
      format.js
    end
  end

  def type_ordem_service
    @tipo_os = params[:type].to_i
    @ordem_services = OrdemService.joins(:client).where(tipo: @tipo_os).order(id: :desc)

    respond_with(@ordem_services) do |format|
      format.html { render :layout => !request.xhr? }
    end
  end

  def search
    if current_user.has_role? :admin
      @q = OrdemService.search(params[:q])
    else
      @q = OrdemService.where(carrier_id: current_user.carrier_id).search(params[:q])
    end
  end

  def close_os
    if !@ordem_service.ordem_service_type_service.present? 
      flash[:danger] = "Can not close without an Order of Seriviço associated service."
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

    @ordem_service.data_fechamento = Time.now.strftime('%Y-%m-%d')
    @ordem_service.status = OrdemService::TipoStatus::FECHADO

    respond_to do |format|
      if @ordem_service.save
        format.html { redirect_to @ordem_service, flash: { success: "Ordem Service was successfully closed." } }
        format.json { head :no_content }
      else
        format.html { redirect_to @ordem_service, flash: { danger: "An error occurred when closing work order." } }
        format.json { render json: @ordem_service.errors, status: :unprocessable_entity }
      end
    end
  end

  def faturamento
    @type_services = TypeService.logistica
    @ordem_service = OrdemService.new
    @ordem_services = OrdemService.where(status: OrdemService::TipoStatus::FECHADO).order('id')
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
    OrdemService.invoice(params[:os][:ids], params[:id_service], params[:valor_total])
    redirect_to billings_path
  end

  def index_agent
    #@q = OrdemService.order('id desc').search(params[:q])
    carrier = current_user.carrier_id.nil? ? -1 : current_user.carrier_id
    @ordem_services = OrdemService.where(carrier_id: carrier, status: OrdemService::TipoStatus::ABERTO).order('id desc')
  end

  def show_agent
    #@ordem_services = OrdemService.where(id: params[:id], carrier_id: current_user.carrier_id)
    @ordem_services = OrdemService.where(id: params[:id])
    respond_with(@ordem_service)
  end

  def request_payables
    @ordem_service_type_service = OrdemServiceTypeService.open
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

  private
    def set_ordem_service
      @ordem_service = OrdemService.find(params[:id])
    end

    def ordem_service_params
      params.require(:ordem_service).permit(:client_id, :data, :estado, :cidade, :valor_receita, :valor_despesas, :valor_liquido, 
        :observacao, :status, :data_entrega_servico, :carrier_id, :billing_client_id, :tipo,

        ordem_service_airs_attributes: [:source_stretch_id, :target_stretch_id, :solicitante, :target_agent_id, :airline_carrier_id, 
          :qtde_volume, :peso, :valor_nf, :total_cubagem, :tarifa_companhia, :tipo_frete, :valor_total, :awb, :voo, :id, :_destroy],

        ordem_service_logistics_attributes: [:driver_id, :delivery_driver_id, :placa, :cte, :danfe_cte,:qtde_volume, :peso, :senha_sefaz, :id, :_destroy],

        cte_keys_attributes: [:cte, :chave, :id, :_destroy],
        nfe_keys_attributes: [:nfe, :chave, :qtde, :id, :_destroy],
        ordem_service_type_service_attributes: [:ordem_service_id, :type_service_id, :valor, :qtde, :qtde_recebida, :valor_pago, :id, :_destroy],
        account_banks_attributes: [:banco, :nome_banco, :tipo_operacao, :agencia, :conta_corrente, :favorecido, :cpf_cnpj, :valor, :id, :_destroy],
        assets_attributes: [:asset, :user_id, :id, :_destroy]

        )
    end
end


class OrdemServicesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_ordem_service, only: [:show, :edit, :update, :destroy, :close_os]
  load_and_authorize_resource
  respond_to :html

  def index
    @q = OrdemService.order('id desc').search(params[:q])
    @ordem_services = @q.result
  end

  def show
    respond_with(@ordem_service)
  end

  def new
    @ordem_service = OrdemService.new
    @ordem_service.ordem_service_type_service.build
    @ordem_service.nfe_keys.build
    respond_with(@ordem_service)
  end

  def edit
     # if @ordem_service.status == OrdemService::TipoStatus::FECHADO
     #   flash[:danger] = "Ordem Service already is closed."
     #  if current_user.has_role? :admin
     #    redirect_to @ordem_service
     #  else
     #    redirect_to show_agent_ordem_service_path(@ordem_service)
     #  end
     #  return
     # end
  end

  def create
    @ordem_service = OrdemService.new(ordem_service_params)
    
    respond_to do |format|
      if @ordem_service.save 
        format.html { redirect_to @ordem_service, flash: { success: "Ordem Service was successfully created." } }
        format.json { render action: 'show', status: :created, location: @ordem_service }
      else
        format.html { render action: 'new' }
        format.json { render json: @ordem_service.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if current_user.has_role? :admin
      respond_to do |format|
        if @ordem_service.update(ordem_service_params) 
          format.html { redirect_to @ordem_service, flash: { success: "Ordem Service was successfully updated." } }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @ordem_service.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        if @ordem_service.update(ordem_service_params) 
          OrdemService.close_os_agent(@ordem_service)
          format.html { redirect_to show_agent_ordem_service_path(@ordem_service.id), flash: { success: "Ordem Service was successfully updated." } }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @ordem_service.errors, status: :unprocessable_entity }
        end
      end
    end  
  end

  def destroy
    @ordem_service.destroy
    respond_with(@ordem_service)
  end

  def search
    @q = OrdemService.search(params[:q])
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

  private
    def set_ordem_service
      @ordem_service = OrdemService.find(params[:id])
    end

    def ordem_service_params
      params.require(:ordem_service).permit(:driver_id, :client_id, :data, :placa, :estado, :cidade, :cte, :danfe_cte, :valor_receita, :valor_despesas, :valor_liquido, 
        :observacao, :status, :qtde_volume, :peso, :data_entrega_servico, :senha_sefaz, :carrier_id, 
        nfe_keys_attributes: [:nfe, :chave, :qtde, :id, :_destroy],
        ordem_service_type_service_attributes: [:ordem_service_id, :type_service_id, :valor, :qtde, :qtde_recebida, :valor_pago, :id, :_destroy],
        account_banks_attributes: [:banco, :nome_banco, :tipo_operacao, :agencia, :conta_corrente, :favorecido, :cpf_cnpj, :valor, :id, :_destroy],
        assets_attributes: [:asset, :user_id, :id, :_destroy]
        )
    end
end

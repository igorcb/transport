class AccountPayablesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_account_payable, only: [:show, :edit, :update, :destroy, :lower, :pay]
  load_and_authorize_resource
  respond_to :html

  def type_account_select
    type_id = params[:id].to_i
    case type_id
      when 1 then suppliers = Supplier.order('nome')
      when 2 then suppliers = Driver.order('nome')
      when 3 then suppliers = Client.order('nome')
      when 4 then suppliers = Employee.order('nome')
      when 5 then suppliers = Carrier.order('nome')
    end
    sup = []
    suppliers.each do |s|
      sup << {:id => s.id, :n => s.nome}
    end
    render :json => {:sup => sup.compact}.as_json
  end

  def sub_centro_custo_by_custo
    #puts ">>>>>>>>>>>>>>>> cost_center_id: #{params[:cost_center_id].to_i}"
    sub_cost_center_id = params[:cost_center_id].to_i
    subs = SubCostCenter.where(:cost_center_id => sub_cost_center_id)
    sub = []
    subs.each do |s|
      sub << {:id => s.id, :n => s.descricao}
    end
    render :json => {:sub => sub.compact}.as_json
  end
  
  #relatorio com quebra de centro de custo
  def cost_centers 
    
  end

  def index
    @account_payables = AccountPayable.order('data_vencimento desc')
    respond_with(@account_payables)
  end

  def show
    respond_with(@account_payable)
  end

  def new
    @account_payable = AccountPayable.new
    respond_with(@account_payable)
  end

  def edit
  end

 def create
    @account_payable = AccountPayable.new(account_payable_params)

    respond_to do |format|
      if @account_payable.save!
        format.html { redirect_to @account_payable, flash: { success: "AccountPayable was successfully created." } }
        format.json { render action: 'show', status: :created, location: @account_payable }
        format.js   { render action: 'show', status: :created, location: @account_payable }
      else
        format.html { render action: 'new' }
        format.json { render json: @account_payable.errors, status: :unprocessable_entity }
        format.js   { render json: @account_payable.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @account_payable.update(account_payable_params)
        format.html { redirect_to @account_payable, flash: { success: "AccountPayable was successfully updated." } }
        format.json { head :no_content }
        format.js   { render action: 'show', status: :created, location: @account_payable }
      else
        format.html { render action: 'edit' }
        format.json { render json: @account_payable.errors, status: :unprocessable_entity }
        format.js   { render json: @account_payable.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @account_payable.destroy
    respond_with(@account_payable)
    # @account_payable.destroy
    # respond_to do |format|
    #   format.html { redirect_to account_payables_url }
    #   format.json { head :no_content }
    # end
  end

  def lower_payables
    @q = AccountPayable.where(status: AccountPayable::TipoStatus::ABERTO).search(params[:q])
    @account_payables = @q.result
    @employees = Employee.order('nome')
  end
  
  def search
    #@q = AccountPayable.where(status: AccountPayable::TipoStatus::ABERTO).order('id desc').search(params[:q])
    @q = AccountPayable.order('data_vencimento desc').search(params[:q])
    @account_payables = @q.result
  end

  def lower
    if @account_payable.status == AccountPayable::TipoStatus::PAGO
      flash[:danger] = "AccountPayable already made payment."
      redirect_to account_payables_path #(params[:id])
      return 
    end
    @cash_accounts = CashAccount.order('nome')
  end

  def lower_all
    AccountPayable.payament_all(params[:os][:ids], params[:valor_total])
    redirect_to lower_payables_path    
  end

  def pay
    if !params[:lower_payables][:cash_account_id].present?
      flash[:danger] = "Conta Corrente can't be blank."
      redirect_to lower_account_payable_path(params[:id])
      return 
    elsif !params[:lower_payables][:data_pagamento].present?
      flash[:danger] = "Data Pagamento can't be blank."
      redirect_to lower_account_payable_path(params[:id])
      return 
    elsif !params[:lower_payables][:valor_pago].present?
      flash[:danger] = "Valor do Pagamento can't be blank."
      redirect_to lower_account_payable_path(params[:id])
      return
    end

    respond_to do |format|
      if @account_payable.payament(params[:lower_payables])
        format.html { redirect_to @account_payable, flash: { success: "Lower AccountsPayable was successful." } }
        #format.json { render action: 'show', status: :created, location: @account_payable }
      else
        format.html { redirect_to @account_payable, flash: { danger: "Could not lower accounts payable was successful." }}
        format.json { render json: @account_payable.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_account_payable
      @account_payable = AccountPayable.find(params[:id])
    end

    def account_payable_params
      params.require(:account_payable).permit(:supplier_id, :cost_center_id, :sub_cost_center_id, :historic_id, :data_vencimento, :documento, 
        :valor, :observacao, :status, :payment_method_id, :type_account, :ordem_service_id,
        lower_payables: [:data_pagamento, :valor_pago, :juros, :desconto, :total_pago],
        assets_attributes: [:asset, :id, :_destroy]
        )
    end
end

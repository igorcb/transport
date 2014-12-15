class AccountPayablesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_account_payable, only: [:show, :edit, :update, :destroy, :lower, :pay]

  respond_to :html, :js

  def type_account_select
    type_id = params[:id].to_i
    case type_id
      when 0 then suppliers = Supplier.order('nome')
      when 1 then suppliers = Driver.order('nome')
      when 2 then suppliers = Client.order('nome')
      when 3 then suppliers = Employee.order('nome')
    end
    sup = []
    suppliers.each do |s|
      sup << {:id => s.id, :n => s.nome}
    end
    render :json => {:sup => sup.compact}.as_json
  end

  def sub_centro_custo_by_custo
    sub_cost_center_id = params[:id].to_i
    subs = SubCostCenter.where(:cost_center_id => sub_cost_center_id)
    sub = []
    subs.each do |s|
      sub << {:id => s.id, :n => s.descricao}
    end
    render :json => {:sub => sub.compact}.as_json
  end

  def index
    @account_payables = AccountPayable.order('id desc')
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
      if @account_payable.save
        format.html { redirect_to @account_payable, flash: { success: "AccountPayable was successfully created." } }
        format.json { render action: 'show', status: :created, location: @account_payable }
      else
        format.html { render action: 'new' }
        format.json { render json: @account_payable.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @account_payable.update(account_payable_params)
        format.html { redirect_to @account_payable, flash: { success: "AccountPayable was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @account_payable.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @account_payable.destroy
    respond_with(@account_payable)
  end

  def lower_payables
    @q = AccountPayable.search(params[:q])
    @employees = Employee.order('nome')
  end
  
  def search
    @q = AccountPayable.where(status: AccountPayable::TipoStatus::ABERTO).order('id desc').search(params[:q])
    @account_payables = @q.result
  end

  def lower
    if @account_payable.status == AccountPayable::TipoStatus::PAGO
      flash[:danger] = "AccountPayable already made payment."
      redirect_to account_payables_path #(params[:id])
      return 
    end
  end

  def lower_all
    AccountPayable.payament_all(params[:os][:ids], params[:valor_total])
    redirect_to lower_payables_path    
  end

  def pay

    if !params[:data_pagamento].present?
      flash[:danger] = "Data Pagamento can't be blank."
      redirect_to lower_account_payable_path(params[:id])
      return 
    elsif !params[:valor_pago].present?
      flash[:danger] = "Valor do Pagamento can't be blank."
      redirect_to lower_account_payable_path(params[:id])
      return
    end

    data = params[:data_pagamento]
    valor = params[:valor_pago].to_f

    respond_to do |format|
      if @account_payable.payament(data, valor,0,0)
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
        :valor, :observacao, :status, :payment_method_id, :type_account,
        assets_attributes: [:asset, :id, :_destroy]
        )
    end
end

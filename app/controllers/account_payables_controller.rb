class AccountPayablesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_account_payable, only: [:show, :edit, :update, :destroy]

  respond_to :html

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
    @account_payables = AccountPayable.all
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

  private
    def set_account_payable
      @account_payable = AccountPayable.find(params[:id])
    end

    def account_payable_params
      params.require(:account_payable).permit(:supplier_id, :cost_center_id, :sub_cost_center_id, :historic_id, :data_vencimento, :documento, :valor, :observacao, :status)
    end
end

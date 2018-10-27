class CashAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cash_account, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
#  respond_to :html

  def index
    @cash_accounts = CashAccount.all
  end

  def show
  end

  def new
    @cash_account = CashAccount.new
  end

  def edit
  end

  def create
    @cash_account = CashAccount.new(cash_account_params)
    respond_to do |format|
      if @cash_account.save
        format.html { redirect_to @cash_account, flash: { success: "Cash Account was successfully created." } }
        format.json { render action: 'show', status: :created, location: @cash_account }
      else
        format.html { render action: 'new' }
        format.json { render json: @cash_account.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @cash_account.update(cash_account_params)
        format.html { redirect_to @cash_account, flash: { success: "Cash Account was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cash_account.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cash_account.destroy
    respond_with(@cash_account)
  end

  private
    def set_cash_account
      @cash_account = CashAccount.find(params[:id])
    end

    def cash_account_params
      params.require(:cash_account).permit(:nome, :bank_id, :agencia, :conta_corrente, :ted_doc)
    end
end

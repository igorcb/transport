class CurrentAccountsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_current_account, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  #respond_to :html

  def index
    @current_accounts = CurrentAccount.all
  end

  def show
  end

  def new
    @current_account = CurrentAccount.new
  end

  def edit
  end

  def create
    @current_account = CurrentAccount.new(current_account_params)
    respond_to do |format|
      if @current_account.save
        format.html { redirect_to @current_account, flash: { success: "Current Account was successfully created." } }
        format.json { render action: 'show', status: :created, location: @current_account }
      else
        format.html { render action: 'new' }
        format.json { render json: @current_account.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @current_account.update(current_account_params)
        format.html { redirect_to @current_account, flash: { success: "Current Account was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @current_account.errors, status: :unprocessable_entity }
      end
    end
 end

  def destroy
    @current_account.destroy
  end

  private
    def set_current_account
      @current_account = CurrentAccount.find(params[:id])
    end

    def current_account_params
      params.require(:current_account).permit(:cash_account_id, :data, :valor, :tipo, :historico)
    end
end

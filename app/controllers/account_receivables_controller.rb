class AccountReceivablesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_account_receivable, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html

  def index
    @account_receivables = AccountReceivable.order('data_vencimento desc')
    respond_with(@account_receivables)
  end

  def show
    respond_with(@account_receivable)
  end

  def new
    @account_receivable = AccountReceivable.new
    respond_with(@account_receivable)
  end
  
  def edit
  end

 def create
    @account_receivable = AccountReceivable.new(account_receivable_params)

    respond_to do |format|
      if @account_receivable.save!
        format.html { redirect_to @account_receivable, flash: { success: "AccountReceivable was successfully created." } }
        format.json { render action: 'show', status: :created, location: @account_receivable }
        format.js   { render action: 'show', status: :created, location: @account_receivable }
      else
        format.html { render action: 'new' }
        format.json { render json: @account_receivable.errors, status: :unprocessable_entity }
        format.js   { render json: @account_receivable.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @account_receivable.update(account_receivable_params)
        format.html { redirect_to @account_receivable, flash: { success: "AccountReceivable was successfully updated." } }
        format.json { head :no_content }
        format.js   { render action: 'show', status: :created, location: @account_receivable }
      else
        format.html { render action: 'edit' }
        format.json { render json: @account_receivable.errors, status: :unprocessable_entity }
        format.js   { render json: @account_receivable.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @account_receivable.destroy
    respond_with(@account_receivable)
  end

  private
    def set_account_receivable
      @account_receivable = AccountReceivable.find(params[:id])
    end

    def account_receivable_params
      params.require(:account_receivable).permit(:client_id, :cost_center_id, :sub_cost_center_id, :historic_id, :data_vencimento, :documento, 
        :valor, :observacao, :ordem_service_id
        #:status, :payment_method_id, :type_account, :ordem_service_id,
        #lower_payables: [:data_pagamento, :valor_pago, :juros, :desconto, :total_pago]
        )
    end
end

class PaymentMethodsController < ApplicationController
  before_action :set_payment_method, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  def index
    @payment_methods = PaymentMethod.all
    respond_with(@payment_methods)
  end

  def show
    respond_with(@payment_method)
  end

  def new
    @payment_method = PaymentMethod.new
    respond_with(@payment_method)
  end

  def edit
  end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    respond_to do |format|
      if @payment_method.save
        format.html { redirect_to @payment_method, flash: { success: "PaymentMethod was successfully created." } }
        format.json { render action: 'show', status: :created, location: @payment_method }
      else
        format.html { render action: 'new' }
        format.json { render json: @payment_method.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @payment_method.update(payment_method_params)
        format.html { redirect_to @payment_method, flash: { success: "PaymentMethod was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @payment_method.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @payment_method.destroy
      respond_with(@payment_method)
    else
      flash[:danger] = "The deletion failed because: " + @payment_method.errors.full_messages.to_sentence
      redirect_to payment_methods_url
    end        
  end

  private
    def set_payment_method
      @payment_method = PaymentMethod.find(params[:id])
    end

    def payment_method_params
      params.require(:payment_method).permit(:descricao)
    end
end

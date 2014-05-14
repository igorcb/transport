class PhoneCallsController < ApplicationController
  before_action :set_phone_call, only: [:show, :edit, :update, :destroy]

  # GET /phone_calls
  # GET /phone_calls.json
  def index
    @phone_calls = PhoneCall.order('created_at desc')
  end

  # GET /phone_calls/1
  # GET /phone_calls/1.json
  def show
  end

  # GET /phone_calls/new
  def new
    @phone_call = PhoneCall.new
  end

  # GET /phone_calls/1/edit
  def edit
  end

  # POST /phone_calls
  # POST /phone_calls.json
  def create
    @phone_call = PhoneCall.new(phone_call_params)

    respond_to do |format|
      if @phone_call.save
        format.html { redirect_to @phone_call, flash: { success: "Phone call was successfully created." } }
        format.json { render action: 'show', status: :created, location: @phone_call }
      else
        format.html { render action: 'new' }
        format.json { render json: @phone_call.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phone_calls/1
  # PATCH/PUT /phone_calls/1.json
  def update
    respond_to do |format|
      if @phone_call.update(phone_call_params)
        format.html { redirect_to @phone_call, flash: { success: "Phone call was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @phone_call.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phone_calls/1
  # DELETE /phone_calls/1.json
  def destroy
    @phone_call.destroy
    respond_to do |format|
      format.html { redirect_to phone_calls_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_phone_call
      @phone_call = PhoneCall.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def phone_call_params
      params.require(:phone_call).permit(:nome, :telefone, :email, :valor, :type_service_id, :assunto, :status)
    end
end

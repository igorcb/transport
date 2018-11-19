class PolicieInsurancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policie_insurance, only: [:show, :edit, :update, :destroy]
  before_action :find_insurer, only: [:new, :create, :index]

  #load_and_authorize_resource

  def index
  end

  def show
  end

  def new
    @policie_insurance = @insurer.policie_insurances.build
  end

  def edit
  end

  def create
    @policie_insurance = @insurer.policie_insurances.build(policie_insurance_params)    
    @policie_insurance.insurer_id = params[:insurer_id]
    respond_to do |format|
      if @policie_insurance.save
        format.html { redirect_to [@insurer, @policie_insurance] , flash: { success: "Policie Insurance was successfully created." } }
        format.json { render action: 'show', status: :created, location: [@insurer, @policie_insurance] }
        format.js   { render action: 'show', status: :created, location: [@insurer, @policie_insurance] }
      else
        format.html { render action: 'new' }
        format.json { render json: @policie_insurance.errors, status: :unprocessable_entity }
        format.js   { render json: @policie_insurance.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @policie_insurance.update(policie_insurance_params)
        format.html { redirect_to [@insurer, @policie_insurance] , flash: { success: "Policie Insurance was successfully updated." } }
        format.json { head :no_content }
        format.js   { render action: 'show', status: :created, location: [@insurer, @policie_insurance] }
      else
        format.html { render action: 'edit' }
        format.json { render json: @policie_insurance.errors, status: :unprocessable_entity }
        format.js   { render json: @policie_insurance.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @policie_insurance.destroy
    respond_with(@policie_insurance)
  end

  private
    def set_policie_insurance
      find_insurer
      @policie_insurance = @insurer.policie_insurances.where(id: params[:id]).first
    end

    def policie_insurance_params
      params.require(:policie_insurance).permit(:insurer_id, :broker_id, :type_policie, :proposal, :policy, :date_start, :date_expired, :value)
    end

    def find_insurer
      @insurer  = Insurer.find(params[:insurer_id])
    end

end

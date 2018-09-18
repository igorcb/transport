class TableInsurancesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_table_insurance, only: [:show, :edit, :update, :destroy]
  before_action :find_insurer, only: [:new, :create, :index]
  #load_and_authorize_resource

  def index
  end

  def show
  end

  def new
    @table_insurance = @insurer.table_insurances.build
  end

  def edit
  end

  def create

    @table_insurance = @insurer.table_insurances.build(table_insurance_params)    
    @table_insurance.insurer_id = params[:insurer_id]
    respond_to do |format|
      if @table_insurance.save
        format.html { redirect_to [@insurer, @table_insurance] , flash: { success: "Table Insurance was successfully created." } }
        format.json { render action: 'show', status: :created, location: [@insurer, @table_insurance] }
        format.js   { render action: 'show', status: :created, location: [@insurer, @table_insurance] }
      else
        format.html { render action: 'new' }
        format.json { render json: @table_insurance.errors, status: :unprocessable_entity }
        format.js   { render json: @table_insurance.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    respond_to do |format|
      if @table_insurance.update(table_insurance_params)
        format.html { redirect_to [@insurer, @table_insurance] , flash: { success: "Table Insurance was successfully updated." } }
        format.json { head :no_content }
        format.js   { render action: 'show', status: :created, location: [@insurer, @table_insurance] }
      else
        format.html { render action: 'edit' }
        format.json { render json: @table_insurance.errors, status: :unprocessable_entity }
        format.js   { render json: @table_insurance.errors, status: :unprocessable_entity }
      end
    end

  end

  def destroy
    @table_insurance = TableInsurance.where(id: params[:id]).first
    Event.create(user: current_user, controller_name: "TableInsurances", action_name: 'destroy' , what: "Deletou a Tabela da Seguradora Origem: #{@table_insurance.state_source}, Destino: #{@table_insurance.state_target}, da Seguradora: #{@table_insurance.insurer_id}, cnpj: #{@table_insurance.insurer.cnpj}, name: #{@table_insurance.insurer.name}")
    @table_insurance.destroy
    redirect_to insurer_table_insurances_path(@insurer)

  end

  private
    def set_table_insurance
      find_insurer
      @table_insurance = @insurer.table_insurances.where(id: params[:id]).first
    end

    def table_insurance_params
      params.require(:table_insurance).permit(:insurer_id, :state_source, :state_target, :percent)
    end

    def find_insurer
      @insurer  = Insurer.find(params[:insurer_id])
    end
end

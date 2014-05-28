class VehiclesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]

  # GET /vehicles
  # GET /vehicles.json
  def index
    @vehicles = Vehicle.all
  end

  # GET /vehicles/1
  # GET /vehicles/1.json
  def show
  end

  # GET /vehicles/new
  def new
    @vehicle = Vehicle.new
    @vehicle.table_prices.build
    @vehicle.assets.build
  end

  # GET /vehicles/1/edit
  def edit
  end

  # POST /vehicles
  # POST /vehicles.json
  def create
    @vehicle = Vehicle.new(vehicle_params)
    #@vehicle.tipo_veiculo = params[:vehicle][:tipo_veiculo].to_i
    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to @vehicle,  flash: { success: "Vehicle was successfully created." } }
        format.json { render action: 'show', status: :created, location: @vehicle }
      else
        format.html { render action: 'new' }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicles/1
  # PATCH/PUT /vehicles/1.json
  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        format.html { redirect_to @vehicle,  flash: { success: "Vehicle was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1
  # DELETE /vehicles/1.json
  def destroy
    @vehicle.destroy
    respond_to do |format|
      format.html { redirect_to vehicles_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vehicle_params
      params.require(:vehicle).permit(:marca, :modelo, :ano, :cor, :tipo_veiculo, :municipio_emplacamento, :estado, :renavan, :chassi, :capacidade, :placa,
        :especie, :numero_eixos, :numero_loks, :grade, :cordas, :lonas, :capacitacao, :kit_quimico, :largura, :altura, :comprimento,
        table_prices_attributes: [:uf_tipo, :tipo, :valor, :id, :_destroy],
        assets_attributes: [:asset, :id, :_destroy]
        )
    end
end

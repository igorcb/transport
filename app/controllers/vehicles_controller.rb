class VehiclesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

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
    @vehicle.drivings.build
    @vehicle.ownerships.build
  end

  # GET /vehicles/1/edit
  def edit
  end

  # POST /vehicles
  # POST /vehicles.json
  def create
    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.user_id = current.user.id
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

  def get_vehicle_by_place
    @vehicle = Vehicle.find_by_placa(params[:place])
    respond_to do |format|
      format.js
    end
  end

  def get_vehicle_by_renavan
    @vehicle = Vehicle.find_by_renavan(params[:renavan])
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vehicle_params
      params.require(:vehicle).permit(:marca, :modelo, :ano, :cor, :tipo, :tipo_veiculo, :tipo_carroceria, :municipio_emplacamento, :estado, :renavan, :chassi, :capacidade, :placa,
        :especie, :numero_eixos, :numero_loks, :grade, :cordas, :lonas, :capacitacao, :kit_quimico, :largura, :altura, :comprimento, 
        :obs, :antt, :qtde_paletes, :tipo_piso_assoalho, :tracked, :capacity,
        table_prices_attributes: [:uf_tipo, :tipo, :valor, :id, :_destroy],
        assets_attributes: [:asset, :id, :_destroy],
        drivings_attributes: [:driver_id, :id, :_destroy],
        ownerships_attributes: [:owner_id, :id, :_destroy]
        )
    end
end

class CheckinsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_checkin, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /checkins
  # GET /checkins.json
  def index
    @checkins = Checkin.all
  end

  # GET /checkins/1
  # GET /checkins/1.json
  def show
  end

  # GET /checkins/new
  def new
    @checkin = Checkin.new
  end

  # GET /checkins/1/edit
  def edit
  end

  # POST /checkins
  # POST /checkins.json
  def create
    @checkin = Checkin.new(checkin_params)

    respond_to do |format|
      if @checkin.save
        if current_user.has_role(:port)
          format.html { redirect_to dashboard_port_path, notice: 'Checkin was successfully created.' }
        else
          format.html { redirect_to @checkin, notice: 'Checkin was successfully created.' }
          format.json { render :show, status: :created, location: @checkin }
        end
      else
        format.html { render :new }
        format.json { render json: @checkin.errors, status: :unprocessable_entity }
      end
    end
  end

  def checkout
    @checkin = Checkin.driver_status(params[:driver_cpf])

    if @checkin.status == "input"
      Checkin.service_checkout(params[:driver_cpf], params[:operation])
      respond_to do |format|
        format.html { redirect_to dashboard_port_path, flash: { success: "Driver was successfully checkout." } }
      end
    else
      #flash[:danger] = "Can not generate Ordem Service while the Input Control is in Typing Digital."
      respond_to do |format|
        format.html { redirect_to dashboard_port_path, flash: { danger: "Can not checkout, is not operation status 'finish'. " } }
      end
    end

    # @vehicle_restriction = VehicleRestriction.find(params[:id])
    # VehicleRestriction.unlock(@vehicle_restriction)
    # respond_to do |format|
    #   format.html { redirect_to vehicle_restrictions_path, flash: { success: "Vehicle Restriction was successfully unlocked." } }
    # end
  end

  # # PATCH/PUT /checkins/1
  # # PATCH/PUT /checkins/1.json
  # def update
  #   respond_to do |format|
  #     if @checkin.update(checkin_params)
  #       format.html { redirect_to @checkin, notice: 'Checkin was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @checkin }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @checkin.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /checkins/1
  # # DELETE /checkins/1.json
  # def destroy
  #   @checkin.destroy
  #   respond_to do |format|
  #     format.html { redirect_to checkins_url, notice: 'Checkin was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checkin
      @checkin = Checkin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checkin_params
      params.require(:checkin).permit(:driver_cpf, :driver_name, :status, :operation, )
    end
end

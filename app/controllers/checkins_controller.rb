class CheckinsController < ApplicationController
  # before_action :authenticate_user!
  # before_action :set_checkin, only: [:show, :edit, :update, :destroy, :get_driver_name_by_cpf]
  #
  # #get_driver_name_by_cpf
  # load_and_authorize_resource

  # GET /checkins
  # GET /checkins.json
  def index
    @checkins = Checkin.order(created_at: :desc)
  end

  # GET /checkins/1
  # GET /checkins/1.json
  def show
    @checkin = Checkin.find(params[:id])
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
    driver = Driver.where(cpf: params[:checkin][:driver_cpf]).first
    if driver.present?
      if DriverRestriction.driver_loking?(driver.id)
        flash[:danger] = "Motorista com restrições, Não é possível fazer o checkin."
        redirect_to dashboard_oper_path
        return
      end
    end
    if VehicleRestriction.check_places_loking?([params[:checkin][:place_horse], params[:checkin][:place_cart_1], params[:checkin][:place_cart_2]])
      flash[:danger] = "Veículo com restrições, Não é possível fazer o checkin."
      redirect_to dashboard_port_path
      return
    end
    @checkin = Checkin.new(checkin_params)

    respond_to do |format|
      if @checkin.save
        if current_user.has_role?(:port)
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

    if @checkin.finish?
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

  def get_driver_name_by_cpf
    @driver = Driver.find_by_cpf(params[:cpf])
    data = @driver.present? ? {name: @driver.nome} : {name: ""}
    render :json => @driver.to_json.force_encoding("UTF-8")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checkin
      @checkin = Checkin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checkin_params
      params.require(:checkin).permit(:driver_cpf, :driver_name, :status, :operation_type, :place_horse, :place_cart_1, :place_cart_2, :door )
    end
end

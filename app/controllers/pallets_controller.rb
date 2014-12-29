class PalletsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_pallet, only: [:show, :edit, :update, :destroy, :driver_select]
  load_and_authorize_resource

  # GET /pallets
  # GET /pallets.json
  def index
    @pallets = Pallet.all
  end

  # GET /pallets/1
  # GET /pallets/1.json
  def show
  end

  # GET /pallets/new
  def new
    @pallet = Pallet.new
  end

  # GET /pallets/1/edit
  def edit
  end

  # POST /pallets
  # POST /pallets.json
  def create
    @pallet = Pallet.new(pallet_params)

    respond_to do |format|
      if @pallet.save
        format.html { redirect_to @pallet, flash: { success: "Pallet was successfully created." }  }
        format.json { render action: 'show', status: :created, location: @pallet }
      else
        format.html { render action: 'new' }
        format.json { render json: @pallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pallets/1
  # PATCH/PUT /pallets/1.json
  def update
    respond_to do |format|
      if @pallet.update(pallet_params)
        format.html { redirect_to @pallet, flash: { success: "Pallet was successfully updated." }  }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pallets/1
  # DELETE /pallets/1.json
  def destroy
    @pallet.destroy
    respond_to do |format|
      format.html { redirect_to pallets_url }
      format.json { head :no_content }
    end
  end
  
  def estoque

  end
  
  def driver_select
    if @pallet.data_agendamento.nil?
      flash[:danger] = "Data Agendamento can not be blank."
      redirect_to pallet_path(@pallet)
      return
    elsif @pallet.qtde.to_i <= 0
      flash[:danger] = "Qtde informed must be greater than zero."
      redirect_to pallet_path(@pallet)
      return
    end
    @drivers = Driver.order('nome')
  end
  
  def create_os
    if params[:driver_id].blank? 
      flash[:danger] = "Driver can not be blank."
      redirect_to driver_select_pallet_path(params[:pallet_id])
      return
    elsif params[:placa].blank? 
      flash[:danger] = "Placa can not be blank."
      redirect_to driver_select_pallet_path(params[:pallet_id])
      return
    elsif params[:estado].blank? 
      flash[:danger] = "Estado can not be blank."
      redirect_to driver_select_pallet_path(params[:pallet_id])
      return
    elsif params[:cidade].blank? 
      flash[:danger] = "Cidade can not be blank."
      redirect_to driver_select_pallet_path(params[:pallet_id])
      return
    end

    @pallet = Pallet.find(params[:pallet_id])
    @pallet.create_os(params[:driver_id], params[:placa], params[:estado], params[:cidade])
    redirect_to ordem_services_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pallet
      @pallet = Pallet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pallet_params
      params.require(:pallet).permit(:client_id, :data_agendamento, :qtde, :data_informada, :qtde_informada, :status)
    end
end

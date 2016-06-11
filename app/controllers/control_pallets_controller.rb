class ControlPalletsController < ApplicationController
  before_action :set_control_pallet, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @control_pallets = ControlPallet.all
    respond_with(@control_pallets)
  end

  def show
    respond_with(@control_pallet)
  end

  def new
    @control_pallet = ControlPallet.new
    respond_with(@control_pallet)
  end

  def edit
  end

  def create
    @control_pallet = ControlPallet.new(control_pallet_params)
    respond_to do |format|
      if @control_pallet.save
        format.html { redirect_to @control_pallet, flash: { success: "Pallet was successfully created." } }
        format.json { render action: 'show', status: :created, location: @control_pallet }
      else
        format.html { render action: 'new' }
        format.json { render json: @control_pallet.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    @control_pallet.update(control_pallet_params)
    respond_with(@control_pallet)
  end

  def destroy
    @control_pallet.destroy
    respond_with(@control_pallet)
  end

  private
    def set_control_pallet
      @control_pallet = ControlPallet.find(params[:id])
    end

    def control_pallet_params
      params.require(:control_pallet).permit(:client_id, :data, :qte, :tipo, :historico, :nfe, :nfd, :nfe_original, :nfd_orginal)
    end
end

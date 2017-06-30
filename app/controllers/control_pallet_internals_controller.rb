class ControlPalletInternalsController < ApplicationController
  before_action :set_control_pallet_internal, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @control_pallet_internals = ControlPalletInternal.all
    respond_with(@control_pallet_internals)
  end

  def show
    respond_with(@control_pallet_internal)
  end

  def new
    @control_pallet_internal = ControlPalletInternal.new
    respond_with(@control_pallet_internal)
  end

  def edit
  end

  def create
    @control_pallet_internal = ControlPalletInternal.new(control_pallet_internal_params)
    @control_pallet_internal.save
    respond_with(@control_pallet_internal)
  end

  def update
    @control_pallet_internal.update(control_pallet_internal_params)
    respond_with(@control_pallet_internal)
  end

  def destroy
    @control_pallet_internal.destroy
    respond_with(@control_pallet_internal)
  end

  private
    def set_control_pallet_internal
      @control_pallet_internal = ControlPalletInternal.find(params[:id])
    end

    def control_pallet_internal_params
      params.require(:control_pallet_internal).permit(:responsable_type, :responsable_id, :type_account, :type_launche, :equipament, :date_launche, :qtde, :historic, :observation)
    end
end

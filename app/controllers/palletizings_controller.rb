class PalletizingsController < ApplicationController
  before_action :set_palletizing, only: [:new, :create]
  def new
  end

  def create
    palletizing = Palletizing.create!(view_mode: params[:mode], status: :started, input_control_id: params[:input_control_id])
    redirect_to palletizing_palletizing_pallets_path(palletizing)
  end

  private
  def set_palletizing
    @input_control = InputControl.where(id: params[:input_control_id]).first

    if @input_control.palletizing.present?
      redirect_to palletizing_palletizing_pallets_path(@input_control.palletizing)
    end
  end

end

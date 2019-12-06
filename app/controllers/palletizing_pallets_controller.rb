class PalletizingPalletsController < ApplicationController
  before_action :set_palletizing
  def index
    @pallets = @palletizing.palletizing_pallet
  end

  def new
  end

  def create
  end

  def delete
  end

  private
  def set_palletizing
    @palletizing = Palletizing.where(id: params[:palletizing_id]).first
    @input_control = @palletizing.input_control
  end
end

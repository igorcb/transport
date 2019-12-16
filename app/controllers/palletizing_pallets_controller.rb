#encoding: utf-8
class PalletizingPalletsController < ApplicationController
  before_action :set_palletizing
  def index
    @pallets = @palletizing.palletizing_pallets
  end

  def new
    @pallet = Pallet.new
    data = PalletizingPallets::GetItemsService.new(@input_control).call
    @items = data[:data].to_json.html_safe
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

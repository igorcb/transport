#encoding: utf-8
class PalletizingPalletsController < ApplicationController
  before_action :set_palletizing
  def index
    @pallets = @palletizing.palletizing_pallets
  end

  def new
    @pallet = PalletizingPallet.new
    data = PalletizingPallets::GetItemsService.new(@input_control).call
    @items = data[:data].to_json.html_safe
  end

  def create
    data = PalletizingPalletProducts::OrganizerDataService.new(params).call
    create = PalletizingPallets::CreateService.new(@palletizing, data).call
    # render inline: data.inspect.html_safe
    redirect_to palletizing_palletizing_pallets_path(@palletizing)
  end

  def show
    @pallet = @palletizing.palletizing_pallets.where(id: params[:id]).first
    @pallet_product = @pallet.palletizing_pallet_products
    @products = @pallet_product.map{|p| {cod_prod: p.product.cod_prod, descricao: p.product.descricao, qtde: p.qtde} }
    if @pallet.type_pallet != "leftover" and @palletizing.view_mode != "single"
      @nfes = @pallet_product.select("DISTINCT nfe_xml_id").map{|p| p.nfe_xml.numero }
    end
  end

  def destroy
    @palletizing.palletizing_pallets.where(id: params[:id]).destroy_all
    redirect_to palletizing_palletizing_pallets_path(@palletizing)
  end

  private
  def set_palletizing
    @palletizing = Palletizing.where(id: params[:palletizing_id]).first
    @input_control = @palletizing.input_control
  end
end
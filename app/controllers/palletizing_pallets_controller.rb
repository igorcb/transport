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
    create = PalletizingPallets::CreateService.new(@palletizing, data, current_user).call
    # render inline: data.inspect.html_safe
    redirect_to palletizing_palletizing_pallets_path(@palletizing)
  end

  def show
    @pallet = @palletizing.palletizing_pallets.where(id: params[:id]).first
    @products = @pallet.palletizing_pallet_products.map{|p| {cod_prod: p.product.cod_prod, descricao: p.product.descricao, qtde: p.qtde} } if @pallet.present?
    @palletizing = @pallet.palletizing
    @input_control = @palletizing.input_control
  end

  def print
    @pallets  = @palletizing.palletizing_pallets
    @pallets  = @palletizing.palletizing_pallets.where(id: params[:pallet]) if params[:pallet].present?

    @company = Company.first
    render layout: false
  end

  # def print
  #   @pallets  = @palletizing.palletizing_pallets
  #   @pallets  = @palletizing.palletizing_pallets.where(id: params[:pallet]) if params[:pallet].present?
  #
  #   @company = Company.first
  #   render layout: false
  # end

  def query_pallet
    @ean = params[:ean]
    @request_items = request.base_url + "/palletizing_pallets/query_pallet/"
    @pallet = PalletizingPallet.where(number: @ean).first
    if @pallet.present?
      @palletizing = @pallet.palletizing
      @input_control = @palletizing.input_control
      @products = @pallet.palletizing_pallet_products.map{|p| {cod_prod: p.product.cod_prod, descricao: p.product.descricao, qtde: p.qtde} } if @pallet.present?
    end
  end


  def destroy
    @palletizing.palletizing_pallets.where(id: params[:id]).destroy_all
    redirect_to palletizing_palletizing_pallets_path(@palletizing)
  end

  private
  def set_palletizing
    @palletizing = Palletizing.where(id: params[:palletizing_id]).first
    @input_control = @palletizing.input_control if @palletizing.present?
  end
end

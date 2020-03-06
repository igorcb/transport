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

  def switch_move_pallet
  end



  # Outputing pallet of house anda inputing into box 
  def by_nfe
    @nfe_xml = NfeXml.where(numero: params[:id]).first
    @pallets = PalletizingPallets::GetAllPalletsByNfeService.new(@nfe_xml.numero).call
  end

  def output_house
    house = House.where(id: params[:id]).first
    result = PalletizingPallets::OutputHouseService.new(house, current_user).call
    flash_message(result)

    redirect_to input_box_palletizing_pallet_path(result[:pallet])
  end

  def input_box
    
  end
  
  

  def new_output_box
    @action = output_box_palletizing_pallets_path
    @ean = params[:ean]
    @pallet = PalletizingPallet.where(number: @ean).first    
  end

  def output_box
    pallet = PalletizingPallet.where(number: params[:ean]).first
    result = PalletizingPallets::OutputBoxService.new(pallet, current_user).call
    flash_message(result)
    if result[:success]
      redirect_to new_input_house_palletizing_pallets_path(pallet: params[:ean]) 
    else
      return redirect_to new_input_house_palletizing_pallets_path(pallet: params[:ean]) if result[:type] = "already_exists"
      redirect_to new_output_box_palletizing_pallets_path(pallet: params[:ean]) 
    end
  end

  def new_input_house
    @pallet = PalletizingPallet.where(number: params[:pallet]).first 
    if @pallet.house.present?
      flash_message({success: false, message: "O palete ja está armazenado."})
      redirect_to new_output_box_palletizing_pallets_path
    end
  end

  def confirm_input_house
  end

  def input_house
    house = House.where(id: params[:house_id]).first
    pallet = PalletizingPallet.where(number: params[:pallet]).first
    result = PalletizingPallets::InputInHouseService.new(house, pallet, current_user).call
    flash_message(result)

    redirect_to new_output_box_palletizing_pallets_path
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

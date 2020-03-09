class AddressesHousesController < ApplicationController


  def index
    # render layout: false
  end

  def show
    @house = House.where(id: params[:id]).first
    @pallet = @house.palletizing_pallet
    @palletizing = @pallet.palletizing
    @input_control = @palletizing.input_control
    @products = @pallet.products
  end

  def houses
    if params[:deposit].present?
      @deposit = Deposit.find(params[:deposit])
      @warehouse = @deposit.warehouse
      @street = @deposit.streets
      @occupied_percent = House.occupied_percent
    end
  end

  def do_occupe
    house = House.find(params[:house_id])
    Addressing::DoOccupeService.new(house).call
    render layout: false
  end

  def do_vacate
    house = House.find(params[:house_id])
    Addressing::DoVacateService.new(house).call
    render layout: false
  end

  def new
  end

  def generator

    address = params.to_unsafe_h[:address]

    result = Addressing::GeneratorService.new(address).call
    redirect_to "/addresses_houses", notice: 'Your generator was successfully updated.'
    # render inline: address.inspect
  end

end

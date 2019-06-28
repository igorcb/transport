class AddressesHousesController < ApplicationController


  def index
    # render layout: false
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

  def teste
    @occupied_percent = House.occupied_percent
    render layout: false
  end

end

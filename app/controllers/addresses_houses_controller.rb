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

  def teste
    @occupied_percent = House.occupied_percent
    render layout: false
  end

end

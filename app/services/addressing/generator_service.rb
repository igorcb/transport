module Addressing
  class GeneratorService

    def initialize(params={})
      # @deposit = Deposit.find(params[:deposit])
      @deposit = params[:deposit]
      @initStreet = params[:initStreet]
      @endStreet = params[:endStreet]
      @maxFloor = params[:maxFloor]
      @maxHouse = params[:maxHouse]
      @spaceHouse = params[:spaceHouse]
    end

    def call
      (@initStreet..@endStreet).each do |s|
        street = Street.create(name: s, deposit_id: @deposit)
        createFloors street
      end
    end


    protected
    def createFloors street
      (1..@maxFloor).each do |f|
        floor = Floor.create(name: f, street_id: street.id)
        createHouses floor
      end
    end

    def createHouses floor
      (1..@maxHouse).each do |h|
        house = House.create(name: h, floor_id: floor.id)
      end
    end


  end
end

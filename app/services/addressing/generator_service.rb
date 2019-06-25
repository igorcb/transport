module Addressing
  class GeneratorService

    def initialize(params={})
      @deposit = Deposit.find(params[:deposit])
      # @deposit = params[:deposit]
      @initStreet = params[:initStreet]
      @endStreet = params[:endStreet]
      @maxFloor = params[:maxFloor]
      @maxHouse = params[:maxHouse]
      @spaceHouse = params[:spaceHouse]
    end

    def call
      (@initStreet..@endStreet).each do |s|
        street = @deposit.streets.create(name: s)
        createFloors street
      end
    end


    protected
    def createFloors street
      (1..@maxFloor).each do |f|
        floor = street.floors.create(name: f)
        createHouses floor
      end
    end

    def createHouses floor
      (1..@maxHouse).each do |h|
        house = floor.houses.create(name: h)
      end
    end


  end
end

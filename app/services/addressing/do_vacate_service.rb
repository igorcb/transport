module Addressing
  class DoVacateService

    def initialize(house)
      @house = house
    end

    def call
      House.where(id: @house.id).update(occupied: false)
    end

  end
end

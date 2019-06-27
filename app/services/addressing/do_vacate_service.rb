module Addressing
  class DoVacateService

    def initialize(house_id)
      @house_id = house_id
    end

    def call
      House.where(id: @house_id).update(occupied: false)
    end

  end
end

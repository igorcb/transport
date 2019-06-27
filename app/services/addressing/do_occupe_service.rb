module Addressing
  class DoOccupeService

    def initialize(house_id)
      @house_id = house_id
    end

    def call
      House.where(id: @house_id).update(occupied: true)
    end

  end
end

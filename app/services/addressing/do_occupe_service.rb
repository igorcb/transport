module Addressing
  class DoOccupeService

    def initialize(house)
      @house = house
    end

    def call
      puts ">>>>>>>>>>>>>>>>>> #{@house.present?}"
      return {success: false, message: "Deposit does not exist."} if !@house.present?

      begin
        ActiveRecord::Base.transaction do
          House.where(id: @house.id).update(occupied: true)
          return {success: true, message: "Generation Houses created successfully."}
        end
      rescue => e
        return {success: false, message: e.message}
      end
    end

  end
end

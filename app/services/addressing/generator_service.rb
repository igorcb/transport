
module Addressing
  class GeneratorService

    def initialize(params={})
      # byebug
      # converte Hash
      params.each do |key, value|
        params[key.to_sym] = value.to_i
      end

      # puts params.inspect
      @deposit = Deposit.where(id: params[:deposit_id]).first
      @initStreet = params[:initStreet].present? ? params[:initStreet] : 0
      @endStreet = params[:endStreet].present? ? params[:endStreet] : 0
      @maxFloor = params[:maxFloor].present? ? params[:maxFloor] : 0
      @maxHouse = params[:maxHouse].present? ? params[:maxHouse] : 0
      @spaceHouse = params[:spaceHouse].present? ? params[:spaceHouse] : 0
    end

    def call
      #byebug
      return {success: false, message: "Deposit does not exist."} if !@deposit.present?
      return {success: false, message: "initStreet or endStreet are zero."} if ((@initStreet.zero?) or (@endStreet.zero?))
      return {success: false, message: "initStreet can not great than endStreet."} if (@initStreet.to_i > @endStreet.to_i )
      return {success: false, message: "maxFloor are zero."} if (@maxFloor.zero?)
      return {success: false, message: "maxHouse are zero."} if (@maxHouse.zero?)
      # return {success: false, message: "spaceHouse are empty."} if (@spaceHouse.zero?)

      begin
        ActiveRecord::Base.transaction do
          (@initStreet..@endStreet).each do |s|
            street = @deposit.streets.create(name: s)
            #createFloors street
            (1..@maxFloor).each do |f|
              floor = street.floors.create(name: f)
              (1..@maxHouse).each do |h|
                # house = floor.houses.create(name: h)
                data = []
                if(@spaceHouse.zero?)
                  data = {name: h}
                else
                  (1..@spaceHouse).each do |space|
                    data[space] = {name: "#{h}#{space}"}
                  end
                  data.delete_at(0);
                end
                house = floor.houses.create(data)
              end
            end
          end
          return {success: true, message: "Generation Houses created successfully."}
        end
      rescue => e
        return {success: false, message: e.message}
      end

    end


    private
    # def createFloors street
    #   (1..@maxFloor).each do |f|
    #     floor = street.floors.create(name: f)
    #     createHouses floor
    #   end
    # end
    #
    # def createHouses floor
    #   (1..@maxHouse).each do |h|
    #     house = floor.houses.create(name: h)
    #   end
    # end


  end
end

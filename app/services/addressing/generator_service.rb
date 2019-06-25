module Addressing
  class GeneratorService

    def initialize(params={})
      #byebug
      @deposit = Deposit.where(id: params[:deposit_id]).first
      @initStreet = params[:initStreet].present? ? params[:initStreet] : nil
      @endStreet = params[:endStreet].present? ? params[:endStreet] : nil
      @maxFloor = params[:maxFloor].present? ? params[:maxFloor] : nil
      @maxHouse = params[:maxHouse].present? ? params[:maxHouse] : nil
      @spaceHouse = params[:spaceHouse].present? ? params[:spaceHouse] : nil
    end

    def call
      #byebug
      return {success: false, message: "Deposit does not exist."} if !@deposit.present?
      return {success: false, message: "initStreet or endStreet are empty."} if ((@initStreet.nil?) or (@endStreet.nil?))
      return {success: false, message: "initStreet can not great than endStreet"} if (@initStreet.to_i > @endStreet.to_i )
      return {success: false, message: "maxFloor are empty."} if @maxFloor.nil?
      return {success: false, message: "maxHouse are empty."} if @maxHouse.nil?
      return {success: false, message: "spaceHouse are empty."} if @spaceHouse.nil?

      begin
        ActiveRecord::Base.transaction do
          (@initStreet..@endStreet).each do |s|
            street = @deposit.streets.create(name: s)
            #createFloors street
            (1..@maxFloor).each do |f|
              floor = street.floors.create(name: f)
              (1..@maxHouse).each do |h|
                house = floor.houses.create(name: h)
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

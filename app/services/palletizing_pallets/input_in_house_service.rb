module PalletizingPallets
  class InputInHouseService

    def initialize(house, pallet, current_user)
      @house = house
      @pallet = pallet
      @current_user = current_user
    end

    def call
      return {success: false, message: "House can't be nil"} if @house.nil?
      return {success: false, message: "Pallet can't be nil"} if @pallet.nil?
      return {success: false, message: "User can't be nil"} if @current_user.nil?

	    begin
        ActiveRecord::Base.transaction do
          
          @house.update!(occupied: true, palletizing_pallet_id: @pallet.id)
          d = DateTime.now
          palletizing_log = PalletizingLog.create!(pallet_number: @pallet.number, type_log: :output, user_id: @current_user.id, historic: "Pallet Nº #{@pallet.number} entrou na casa #{@house.name} em #{d.strftime("%d/%m/%Y")} às #{d.strftime("%H:%M:%S")}")
          return {success: true, message: "Sucesso!"}
        end
      rescue => e
        puts e.message
        return {success: false, message: e.message}
      end

    end

    private

  end
end

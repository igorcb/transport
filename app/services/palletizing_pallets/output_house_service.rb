module PalletizingPallets
  class OutputHouseService

    def initialize(house, current_user)
      @house = house
      @current_user = current_user
    end
    
    def call
      return {success: false, message: "House can't be nil"} if @house.nil?
      @pallet = @house.palletizing_pallet
      return {success: false, message: "Pallet can't be nil"} if @pallet.nil?
      return {success: false, message: "User can't be nil"} if @current_user.nil?

	    begin
        ActiveRecord::Base.transaction do
          
          @house.update!(occupied: false, palletizing_pallet_id: nil)
          d = DateTime.now
          palletizing_log = PalletizingLog.create!(pallet_number: @pallet.number, type_log: :output, user_id: @current_user.id, historic: "Pallet Nº #{@pallet.number} saiu da casa #{@house.name} no endereço #{@house.address} em #{d.strftime("%d/%m/%Y")} às #{d.strftime("%H:%M:%S")}")
          return {success: true, message: "Retirado com sucesso!", pallet: @pallet}
        end
      rescue => e
        puts e.message
        return {success: false, message: e.message}
      end

    end

    private

  end
end

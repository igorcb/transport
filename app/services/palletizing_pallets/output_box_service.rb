module PalletizingPallets
  class OutputBoxService

    def initialize(pallet, current_user)
      @pallet = pallet
      @current_user = current_user
    end

    def call
      return {success: false, message: "Pallet can't be nil"} if @pallet.nil?
      return {success: false, message: "User can't be nil"} if @current_user.nil?

	    begin
        ActiveRecord::Base.transaction do

          d = DateTime.now
          palletizing_log = PalletizingLog.create!(pallet_number: @pallet.number, type_log: :output, user_id: @current_user.id, historic: "Pallet Nº #{@pallet.number} saiu do box #{d.strftime("%d/%m/%Y")} às #{d.strftime("%H:%M:%S")}")
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

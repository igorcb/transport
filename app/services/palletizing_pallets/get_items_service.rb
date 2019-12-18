module PalletizingPallets
  class GetItemsService

    def initialize(input_control)
      @input_control = input_control
    end

    def call

      return {success: false, message: "Input control can't be blank."} if @input_control.blank?
      @palletizing = @input_control.palletizing
      return {success: false, message: "Paletizing can't be blank."} if @palletizing.blank?

	    begin
        ActiveRecord::Base.transaction do

          view_mode = @palletizing.view_mode
          if view_mode == "by_nfe"
            PalletizingPallets::GetItemsByNfeService.new(@input_control).call
          elsif view_mode == "by_customer"
            PalletizingPallets::GetItemsByCustomerService.new(@input_control).call
          end

        end
      rescue => e
        puts e.message
        return {success: false, message: e.message}
      end

    end

    private

  end
end

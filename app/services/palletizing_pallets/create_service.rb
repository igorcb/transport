module PalletizingPallets
  class CreateService

    def initialize(palletizing, data_products)
      @palletizing = palletizing
      @data_products = data_products[:data]
      @type = data_products[:type]
    end

    def call

      return {success: false, message: "Palletizing can't be blank."} if @palletizing.blank?

	    begin
        ActiveRecord::Base.transaction do
          qtde_sku = @data_products.count
          type = qtde_sku > 1 ? "mixed" : "exclusive"
          type = "leftover" if @type == "sobra"

          @palletizing_pallet =  PalletizingPallet.create!({number: Time.zone.now.to_formatted_s(:number), type_pallet: type, palletizing_id: @palletizing.id})
          @palletizing_pallet_product = @palletizing_pallet.palletizing_pallet_products.create!(@data_products)
					return {success: true, message: "created successful."}

        end
      rescue => e
        puts e.message
        return {success: false, message: e.message}
      end

    end

    private

  end
end

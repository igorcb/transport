module PalletizingPallets
  class GetAllPalletsByNfeService

    def initialize(nfes)
      @nfes = nfes
    end

    def call

      return {success: false, message: "Palletizing can't be blank."} if @nfes.blank?

	    begin
        ActiveRecord::Base.transaction do

          pallets = PalletizingPallet.joins('LEFT JOIN "palletizing_pallet_products" ON  "palletizing_pallets"."id" = "palletizing_pallet_products"."palletizing_pallet_id"')
                                      .joins('INNER JOIN "nfe_xmls" ON  "palletizing_pallet_products"."nfe_xml_id" = "nfe_xmls"."id"')
                                      .where(nfe_xmls: { numero: [@nfes]})

					# return {success: true, message: "created successful."}
          return pallets
        end
      rescue => e
        puts e.message
        return {success: false, message: e.message}
      end

    end

    private

  end
end

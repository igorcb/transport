module PalletizingPallets
  class PalletsByNfeService

    def initialize(nfes)
      @nfes = nfes
    end

    def call

      return {success: false, message: "Palletizing can't be blank."} if @nfes.blank?

	    begin
        ActiveRecord::Base.transaction do

          qtde_pallet = PalletizingPallet.joins('LEFT JOIN "palletizing_pallet_products" ON  "palletizing_pallets"."id" = "palletizing_pallet_products"."palletizing_pallet_id"')
                                  .joins('INNER JOIN "nfe_xmls" ON  "palletizing_pallet_products"."nfe_xml_id" = "nfe_xmls"."id"')
                                  .where(nfe_xmls: { numero: [@nfes]})
                                  .group("palletizing_pallets")
                                  .count("palletizing_pallets")
                                  .count
					# return {success: true, message: "created successful."}
          return qtde_pallet
        end
      rescue => e
        puts e.message
        return {success: false, message: e.message}
      end

    end

    private

  end
end

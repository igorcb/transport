module PalletizingPalletProducts
  class OrganizerDataService

    def initialize(hash)
      @item_ids = hash[:item_ids]
      @qtdes = hash[:qtdes]
    end

    def call

      return {success: false, message: "Items ids can't be blank."} if @item_ids.blank?

	    begin
        ActiveRecord::Base.transaction do

          i = 0
          data = []
          @item_ids.each do |item_id|
            item = ItemInputControl.where(id: item_id).first
            data.push({product_id: item.product_id, nfe_xml_id: item.nfe_xml_id, qtde: @qtdes[i]})
            i += 1
          end
          return  data

        end
      rescue => e
        puts e.message
        return {success: false, message: e.message}
      end

    end

    private

  end
end

module NfeXmls
  class CalcItemNfeQtdePalletService

    def initialize(product, qtde)
      @product = product
      @qtde = qtde
    end

    def call

      return {success: false, message: "Product is not blank."} if @product.blank?
      return {success: false, message: "Product, box_by_pallet is not blank."} if @product.box_by_pallet.blank?
      return {success: false, message: "Qtde products is not present."} if @qtde.blank?

	    begin
        ActiveRecord::Base.transaction do

          result = @qtde.divmod(@product.box_by_pallet)
          pallets = (result[1].to_f > 0.0) ? result[0] + 1 : result[0]
          qtde_pallet = pallets.to_f.round

					return {success: true, message: "Calculation successful.", qtde_pallet: qtde_pallet}

        end
      rescue => e
        puts e.message
        return {success: false, message: e.message}
      end

    end

    private

  end
end

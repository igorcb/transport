module PalletizingPallets
  class GetItemsSingleService

    def initialize(input_control)
      @input_control = input_control
    end

    def call

      return {success: false, message: "Input control can't be blank."} if @input_control.blank?
      @palletizing = @input_control.palletizing
      return {success: false, message: "Paletizing can't be blank."} if @palletizing.blank?

	    begin
        ActiveRecord::Base.transaction do
            data = [];
            data[0] = {title: "todos os ítems", nfes: [group_name: "", items: []]}
            @input_control.item_input_controls.each do |item|
              product = item.product
              qtde_palletizing = @palletizing.palletizing_pallets.joins(:palletizing_pallet_products).where(:palletizing_pallet_products => {product_id: product.id}).sum(:qtde)
              # puts ">>>>>>>>>>>>>>>>>>>>>>>>>#{qtde_palletizing}"

              breakdown = @input_control.breakdowns.where(product_id: product.id).first
              avarias = breakdown.avarias.to_i if breakdown.present?
              faltas = breakdown.faltas.to_i if breakdown.present?
              qtde = item.qtde.to_i - avarias.to_i - faltas.to_i - qtde_palletizing.to_i
              suggested_pallet = NfeXmls::CalcItemNfeQtdePalletService.new(product, qtde).call
              data[0][:nfes][0][:items].push({item_id: item.id, cod_prod: product.cod_prod, product_description: product.descricao, qtde: qtde, suggested_pallet: suggested_pallet[:qtde_pallet], type: "item"})
            end


					return {success: true, message: "Calculation successful.", data: data}

        end
      rescue => e
        puts e.message
        return {success: false, message: e.message}
      end

    end

    private

  end
end

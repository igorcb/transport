module PalletizingPallets
  class GetItemsByCustomerService

    def initialize(input_control)
      @input_control = input_control
    end

    def call

      return {success: false, message: "Input control can't be blank."} if @input_control.blank?
      @palletizing = @input_control.palletizing
      return {success: false, message: "Paletizing can't be blank."} if @palletizing.blank?

	    begin
        ActiveRecord::Base.transaction do
          nfe_xml_clientes = NfeXml.joins(:target_client).where(nfe_type: "InputControl", nfe_id: @input_control.id).order(:target_client_id)
          data = []
          index = 0
          nfe_xml_clientes.each do |nfe|
            data[index] = {group_name: "Cliente: #{nfe.target_client.nome}", items: []}
            nfe.item_input_controls.each do |item|
              product = item.product
              qtde_palletizing = @palletizing.palletizing_pallets.joins(:palletizing_pallet_products).where(:palletizing_pallet_products => {product_id: product.id, nfe_xml_id: nfe.id}).sum(:qtde)
              # puts ">>>>>>>>>>>>>>>>>>>>>>>>>#{qtde_palletizing}"

              breakdown = @input_control.breakdown_nfe_xmls.where(nfe_xml_id: nfe, product_id: product.id).first
              avarias = breakdown.avarias.to_i if breakdown.present?
              faltas = breakdown.faltas.to_i if breakdown.present?
              qtde = item.qtde.to_i - avarias.to_i - faltas.to_i - qtde_palletizing.to_i
              suggested_pallet = NfeXmls::CalcItemNfeQtdePalletService.new(product, qtde).call
              data[index][:items].push({item_id: item.id, cod_prod: product.cod_prod, product_description: product.descricao, qtde: qtde, suggested_pallet: suggested_pallet[:qtde_pallet], type: "item"})
            end

            index += 1
          end

          # sobras
          breakdowns = @input_control.breakdowns.where("sobras IS NOT ?", nil)
          if breakdowns.present?
            data[index] = {group_name: "Sobras", items: []}

            breakdowns.each do |breakdown|
              product = breakdown.product
              qtde_palletizing = @palletizing.palletizing_pallets.joins(:palletizing_pallet_products).where(:type_pallet => :leftover, :palletizing_pallet_products => {product_id: product.id}).sum(:qtde)
              qtde = breakdown.sobras.to_i - qtde_palletizing.to_i
              suggested_pallet = NfeXmls::CalcItemNfeQtdePalletService.new(product, qtde).call
              data[index][:items].push({item_id: breakdown.id, cod_prod: product.cod_prod, product_description: product.descricao, qtde: qtde, suggested_pallet: suggested_pallet[:qtde_pallet], type: "sobra"})
            end

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

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
          clientes = NfeXml.select(:target_client_id).distinct.joins(:target_client).where(nfe_type: "InputControl", nfe_id: @input_control.id)

          data = []
          index = 0
          clientes.each do |client|
            data[index] = {title: "Cli: #{client.target_client.fantasia.titleize}", nfes: []}
            nfe_xml = @input_control.nfe_xmls.where(target_client_id: client.target_client_id)
            index_nfe = 0
            nfe_xml.each do |nfe|
              data[index][:nfes][index_nfe] = {group_name: "Nfe: #{nfe.numero.to_i}" , items: []}

              nfe.item_input_controls.each do |item|
                product = item.product
                qtde_palletizing = @palletizing.palletizing_pallets.joins(:palletizing_pallet_products).where(:palletizing_pallet_products => {product_id: product.id, nfe_xml_id: nfe.id}).sum(:qtde)
                # puts ">>>>>>>>>>>>>>>>>>>>>>>>>#{qtde_palletizing}"

                breakdown = @input_control.breakdown_nfe_xmls.where(nfe_xml_id: nfe, product_id: product.id).first
                avarias = breakdown.avarias.to_i if breakdown.present?
                faltas = breakdown.faltas.to_i if breakdown.present?
                qtde = item.qtde.to_i - avarias.to_i - faltas.to_i - qtde_palletizing.to_i
                suggested_pallet = NfeXmls::CalcItemNfeQtdePalletService.new(product, qtde).call
                data[index][:nfes][index_nfe][:items].push({item_id: item.id, cod_prod: product.cod_prod, product_description: product.descricao.titleize, qtde: qtde, suggested_pallet: suggested_pallet[:qtde_pallet], type: "item"})
              end

              index_nfe += 1
            end
            index += 1
          end


          # sobras
          breakdowns = @input_control.breakdowns.where("sobras IS NOT ?", nil)
          if breakdowns.present?
            data[index] = {title: "Sobras", nfes: [{group_name: "", items: []}]}

            breakdowns.each do |breakdown|
              product = breakdown.product
              qtde_palletizing = @palletizing.palletizing_pallets.joins(:palletizing_pallet_products).where(:type_pallet => :leftover, :palletizing_pallet_products => {product_id: product.id}).sum(:qtde)
              qtde = breakdown.sobras.to_i - qtde_palletizing.to_i
              suggested_pallet = NfeXmls::CalcItemNfeQtdePalletService.new(product, qtde).call
              data[index][:nfes][0][:items].push({item_id: breakdown.id, cod_prod: product.cod_prod, product_description: product.descricao, qtde: qtde, suggested_pallet: suggested_pallet[:qtde_pallet], type: "sobra"})
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

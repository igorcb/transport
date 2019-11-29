module BreakdownNfeXmls
  class FaltaIntoNfeService

    def initialize(input_control)
      @input_control = input_control
    end

    def call
      #byebug
      # validations object
      return {success: false, message: "input control is not found."} if !@input_control.present?
      @faltas = @input_control.breakdowns.where("faltas != ?", 0)

      begin
        # byebug

        ActiveRecord::Base.transaction do

          data = []
          @faltas.each do |falta|
            product = Product.where(id: falta.product_id).first
            item_input_controls = @input_control.item_input_controls.where(product_id: product.id)

            faltas_qtde = falta.faltas.to_i
            item_input_controls.each do |item_input_control|
              if item_input_control.qtde.to_i >= faltas_qtde
                data.push({nfe_xml_id: item_input_control.nfe_xml_id, faltas:  faltas_qtde, input_control_id: @input_control.id, product_id: product.id, type_breakdown: :primeira_perna_l7, unid_medida: item_input_control.unid_medida})
                break
              else
                data.push({nfe_xml_id: item_input_control.nfe_xml_id, faltas:  item_input_control.qtde.to_i, input_control_id: @input_control.id, product_id: product.id, type_breakdown: :primeira_perna_l7, unid_medida: item_input_control.unid_medida})
                faltas_qtde = (item_input_control.qtde.to_i - faltas_qtde) * -1
              end
            end
          end

          create_or_update(data)

        end
        return {success: true, message: "Breakdown on input_control created successfully."}
      rescue => e
        return {success: false, message: e.message}
      end
    end

    private
    def create_or_update(datas)
      # return BreakdownNfeXml.all
      datas.each do |data|
        breakdown_nfe_xml = @input_control.breakdown_nfe_xmls.where("nfe_xml_id=? AND product_id=?", data[:nfe_xml_id], data[:product_id])
        if breakdown_nfe_xml.present?
          breakdown_nfe_xml.update(data)
        else
          BreakdownNfeXml.create!(data)
        end
      end
    end
  end

end

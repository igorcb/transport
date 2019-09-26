module Conferences
  class ConferenceItemBreakdownCreateService

    def initialize(input_control, product, qtde)
      @input_control = input_control
      @product = product
      @qtde = qtde
    end

    def call
      #byebug
      # validations object
      return {success: false, message: "InputControl is not found."} if !@input_control.present?
      return {success: false, message: "Product is not found."} if !@product.present?
      @item_input_control = ItemInputControl.where("input_control_id = ? and product_id = ?", @input_control.id, @product.id).last
      return {success: false, message: "Quantity avaria is bigger than quantity item."} if @qtde.to_f > @item_input_control.qtde.to_f
      begin
        # byebug

        ActiveRecord::Base.transaction do
          breakdown = @input_control.breakdowns.create!(
                            nfe_xml_id: @item_input_control.nfe_xml_id,
                            product_id: @product.id,
                            unid_medida: "CX",
                            type_breakdown: Breakdown::TypeBreakdown::PRIMEIRA_PERNA_TRANSP,
                            avarias: @qtde
                          )
        end
        return {success: true, message: "Breakdown on input_control created successfully."}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end

end

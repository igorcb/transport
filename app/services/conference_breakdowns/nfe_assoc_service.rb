module ConferenceBreakdowns
  class NfeAssocService

    def initialize(input_control)
      @input_control = input_control
    end

    def call
      #byebug
      # validations object
      return {success: false, message: "input control is not found."} if !@input_control.present?
      @conference = @input_control.conferences.where(approved: :yes).last
      @conference_breakdowns = @conference.conference_breakdowns

      begin
        # byebug

        ActiveRecord::Base.transaction do

          data = []
          @conference_breakdowns.each do |conference_breakdown|
            product = Product.where(id: conference_breakdown.product_id).first
            item_input_controls = @input_control.item_input_controls.where(product_id: product.id)

            avarias_qtde = conference_breakdown.qtde.to_i
            item_input_controls.each do |item_input_control|
              if item_input_control.qtde.to_i >= avarias_qtde
                data.push({nfe_xml_id: item_input_control.nfe_xml_id, avarias:  avarias_qtde, input_control_id: @input_control.id, product_id: product.id })
                break
              else
                data.push({nfe_xml_id: conference_breakdown.nfe_xml_id, avarias:  item_input_control.qtde.to_i, input_control_id: @input_control.id, product_id: product.id })
                avarias_qtde = (item_input_control.qtde.to_i - avarias_qtde) * -1
              end
            end
          end

          BreakdownNfeXml.create!(data)

        end
        return {success: true, message: "Breakdown on input_control created successfully."}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end

end

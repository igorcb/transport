module ConferenceBreakdowns
  class FinishService

    def initialize(input_control)
      @input_control = input_control
    end

    def call
      #byebug
      # validations object
      return {success: false, message: "InputControl is not found."} if !@input_control.present?
      @conference_breakdowns = @input_control.conferences.last.conference_breakdowns
      return {success: false, message: "conference_breakdowns is not found."} if !@conference_breakdowns.present?

      begin
        # byebug

        ActiveRecord::Base.transaction do

          breakdown_array = []
          @conference_breakdowns.each do |cb|
            item_input_control = @input_control.item_input_controls.where(product_id: cb.product_id).first

            breakdown_array.push({
                                # nfe_xml_id: item_input_control.nfe_xml_id,
                                product_id: cb.id,
                                unid_medida: cb.product.unid_medida,
                                type_breakdown: Breakdown::TypeBreakdown::PRIMEIRA_PERNA_TRANSP,
                                avarias: cb.qtde
                              })
          end

          @input_control.breakdowns.create!(breakdown_array)
          @input_control.update(date_finish_avaria: Date.today, time_finish_avaria: Time.now)
        end
        return {success: true, message: "Breakdown on input_control created successfully."}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end

end

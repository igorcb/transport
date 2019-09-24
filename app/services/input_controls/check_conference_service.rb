module InputControls
  class CheckConferenceService

    def initialize(input_control)
      @input_control = input_control
    end

    def call
      #byebug
      return {success: false, message: "Input control is not present."} if !@input_control.present?
      @item_input_control = ItemInputControl.select(:product_id).where(input_control_id: @input_control.id).group(:product_id).sum(:qtde)
      @conference = Conference.where(conference_id: @input_control.id, conference_type: "InputControl").last
      return {success: false, message: "Conference is not found."} if !@conference.present?
      @conference_items = @conference.conference_items.select(:product_id).group(:product_id).sum(:qtde_oper)

      begin
        # byebug

        ActiveRecord::Base.transaction do
          # puts @item_input_control[219]
          @conference_items.each do |conference_item|
            product_id = conference_item[0]
            if @item_input_control[product_id].to_f != conference_item[1].to_f
              Conference.where(id: @conference.id).update_all(approved: "not")
              return {success: false, message: "Conference was not approved."}
              break
            end
          end
          if @conference_items.values.sum.to_f != @item_input_control.values.sum.to_f
            Conference.where(id: @conference.id).update_all(approved: "not")
            return {success: false, message: "Products number is not aggre"}
          end
        end
        Conference.where(id: @conference.id).update_all(approved: "yes")
        return {success: true, message: "conference successfully approved."}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end

end

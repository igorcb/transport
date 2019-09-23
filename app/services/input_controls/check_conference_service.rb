module InputControls
  class CheckConferenceService

    def initialize(input_control)
      @input_control = input_control
    end

    def call
      #byebug
      return {success: false, message: "ERROR: input control is not present."} if !@input_control.present?
      @item_input_control = ItemInputControl.select(:product_id).where(input_control_id: @input_control.id).group(:product_id).sum(:qtde)
      @conference = Conference.where(conference_id: @input_control.id, conference_type: "InputControl").last
      return {success: false, message: "ERROR: @conference is not found."} if !@conference.present?
      @conference_items = @conference.conference_items.select(:product_id).group(:product_id).sum(:qtde_oper)

      begin
        # byebug

        ActiveRecord::Base.transaction do
          # puts @item_input_control[219]
          if @conference_items.count != @item_input_control.count
            return {success: false, message: "Products number is not aggre"}
          end
          @conference_items.each do |conference_item|
            product_id = conference_item[0]
            if @item_input_control[product_id] != conference_item[0]
              return {success: false, message: "The product #{product_id} has different quantity"}
              break
            end
          end
        end
        return {success: true, message: "Conference was success"}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end

end

module Conferences
  class ConferenceBreakdownCreateService

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
      @conference = @input_control.conferences.last
      return {success: false, message: "Conference is not found."} if !@conference.present?
      begin
        # byebug

        ActiveRecord::Base.transaction do
          breakdown = @conference.conference_breakdowns.where(product_id: @product.id).first
          @qtde = breakdown.nil? ? @qtde : @qtde.to_i + breakdown.qtde

          breakdown = ConferenceBreakdown.where(conference_id: @conference.id, product_id: @product.id).update_or_create(
                            product_id: @product.id,
                            qtde: @qtde
                          )
        end
        return {success: true, message: "Conference breakdown created successfully."}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end

end

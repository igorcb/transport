module ConferenceBreakdowns
  class CreateService

    def initialize(input_control, product, qtde, images)
      @input_control = input_control
      @product = product
      @qtde = qtde
      @images = images
    end

    def call
      #byebug
      # validations object
      return {success: false, message: "InputControl is not found."} if !@input_control.present?
      return {success: false, message: "Product is not found."} if !@product.present?
      @conference = @input_control.conferences.last
      return {success: false, message: "Conference is not found."} if !@conference.present?

      # has_product = @conference.conference_items.where(product_id: product.id).first
      # return {success: false, message: "Product don't exists this conference."} if !has_product.present?

      return {success: true, message: "resposta: #{has_product}"}
      begin
        # byebug

        ActiveRecord::Base.transaction do
          breakdown = @conference.conference_breakdowns.where(product_id: @product.id).first
          @qtde = breakdown.nil? ? @qtde : @qtde.to_i + breakdown.qtde

          breakdown = ConferenceBreakdown.where(conference_id: @conference.id, product_id: @product.id).update_or_create(
                            product_id: @product.id,
                            qtde: @qtde,
                            assets_attributes: {assets: @images}
                          )
        end
        return {success: true, message: "Conference breakdown created successfully."}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end

end

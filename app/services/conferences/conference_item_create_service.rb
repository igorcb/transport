module Conferences
  class ConferenceItemCreateService

    def initialize(params={})
      params.each do |key, value|
        params[key.to_sym] = value.to_i
      end
      @input_control_id = params[:input_control_id].present? ? params[:input_control_id] : nil
      @product_id = params[:product_id].present? ? params[:product_id] : nil
      @qtde_oper = params[:qtde_oper].present? ? params[:qtde_oper] : nil
      @input_control = InputControl.where(id: @input_control_id).first
      @product = Product.where(id: @product_id).first
    end

    def call
      #byebug
      # validations params
      return {success: false, message: "Param InputControl is not found."} if @input_control_id.nil?
      return {success: false, message: "Param Product is not found."} if @product_id.nil?
      return {success: false, message: "Param Qtde is not found."} if @qtde_oper.nil?

      # validations object
      return {success: false, message: "InputControl is not found."} if !@input_control.present?
      @conference = @input_control.conferences.last
      return {success: false, message: "Conferences is not found."} if !@conference.present?
      return {success: false, message: "Produc is not found."} if !@product.present?

      begin
        # byebug

        ActiveRecord::Base.transaction do
          conference_item = ConferenceItem.create!(conference_id: @conference.id, product_id: @product.id, qtde_oper: @qtde_oper)
        end
        return {success: true, message: "Conference on input_control created successfully."}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end

end

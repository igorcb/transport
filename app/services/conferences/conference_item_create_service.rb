module Conferences
  class ConferenceItemCreateService

    def initialize(params={})
      params.each do |key, value|
        params[key.to_sym] = value.to_i
      end

      @conference_id = params[:conference_id].present? ? params[:conference_id] : nil
      @product_id = params[:product_id].present? ? params[:product_id] : nil
      @qtde_oper = params[:qtde_oper].present? ? params[:qtde_oper] : nil
    end

    def call
      #byebug
      return {success: false, message: "conference_id is not found."} if !@conference_id.present?

      begin
        # byebug

        ActiveRecord::Base.transaction do
          conference_item = ConferenceItem.new
          conference_item.conference_id = @conference_id
          conference_item.product_id = @product_id
          conference_item.qtde_oper = @qtde_oper
          conference_item.save
        end
        return {success: true, message: "Conference on input_control created successfully."}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end

end

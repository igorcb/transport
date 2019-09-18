module InputControls
  class ConferenceItemService

    def initialize(input_control)
      @input_control = input_control
    end

    def call
      #byebug
      return {success: false, message: "Input Control id is not exist."} if @input_control_id.nil?
      return {success: false, message: "Input Control data is not exist."} if @input_control.nil?

      begin
        # byebug

        ActiveRecord::Base.transaction do
          conference = @input_control.conferences.last
          @conference_items = conference.conference_items
        end
        return {success: true, message: "Conference on input_control created successfully."}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end

end

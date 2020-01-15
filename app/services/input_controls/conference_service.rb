module InputControls
  class ConferenceService

    def initialize(input_control, user)
      @user = user
      @input_control = input_control
    end

    def call
      #byebug
      return {success: false, message: "Input Control and user is not exist."} if @input_control.nil? && @user.nil?
      return {success: false, message: "There is already a conference started."} if Conference.check_status_in_start?("InputControl", @input_control.id)

      begin
        # byebug
        ActiveRecord::Base.transaction do
          @input_control.update_attributes(status: InputControl::TypeStatus::CONFERENCE)
          @conference = @input_control.conferences.create!(date_conference: Date.current, start_time: Time.now, user: @user, status: :start, approved: :not)
          #InputControl.where(id: @input_control.id).update_all(status: InputControl::TypeStatus::CONFERENCE)
        end
        return {success: true, message: "Conference on input_control created successfully."}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end

end

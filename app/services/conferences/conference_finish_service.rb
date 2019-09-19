module Conferences
  class ConferenceFinishService

    def initialize(conference)
      @conference = conference
    end

    def call
      #byebug
      return {success: false, message: "conference is not found."} if !@conference.present?

      begin
        # byebug

        ActiveRecord::Base.transaction do
          @conference.update(finish_time: Time.current, status: :finish)
        end
        return {success: true, message: "Conference on input_control created successfully."}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end

end

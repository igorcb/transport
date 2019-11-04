module Conferences
  class DuplicateConferenceService

    def initialize(input_control, user)
      @user = user
      @input_control = input_control
    end

    def call
      #byebug
      return {success: false, message: "input_control is not found."} if !@input_control.present?
      @conference = @input_control.conferences.last
      return {success: false, message: "conference is not found."} if !@conference.present?
      @conference_items = @conference.conference_items
      return {success: false, message: "conference_items is not found."} if !@conference_items.present?

      begin
        # byebug

        ActiveRecord::Base.transaction do
          # Create conference
          # copy_conference = @conference.as_json
          # copy_conference["id"]=nil
          # copy_conference["approved"]=:waiting
          # copy_conference["created_at"] = nil
          # copy_conference["updated_at"] = nil
          # copy_conference["start_time"] = Date.current
          # copy_conference["finish_time"]= nil
          # return copy_conference.compact!
          conference_new = @input_control.conferences.create!(date_conference: Date.current, start_time: Time.zone.now, status: :start, approved: :waiting, user_id: @user.id)

          # Create conference items
          @conference_items.each { |conference_item|
            copy_conference_item = conference_item.as_json
            copy_conference_item["id"]=nil
            copy_conference_item["conference_id"]=conference_new.id
            copy_conference_item["created_at"]=nil
            copy_conference_item["updated_at"]=nil
            ConferenceItem.create!(copy_conference_item.compact!)
          }

        end
        return {success: true, message: "Conference duplicated successfully."}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end

end

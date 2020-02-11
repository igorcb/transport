module Checkins
  class DestroyService
    def initialize(checkin)
      @checkin = checkin
    end
    def call
      return {success: false, message: "when checkin is not present."} if @checkin.nil?
      begin
        ActiveRecord::Base.transaction do
          @checkin.destroy          
        end
        return {success: true, message: "success!"}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end
end
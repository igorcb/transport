module Boardings
  class DeclinedService

    def initialize(boarding, user)
      @user = user
      @boarding = ordem_service_ids
    end

    def call
      #byebug
      return {success: false, message: "User not information."} if @user.blank?

      begin
        ActiveRecord::Base.transaction do
          return {success: true, message: "Boarding created successfully."}
        end
      rescue => e
        return {success: false, message: e.message}
      end
    end

  private

  end
end

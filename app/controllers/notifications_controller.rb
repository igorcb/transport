class NotificationsController < ApplicationController
	before_filter :authenticate_user!

	def index
		@notifications = unreader
	end

	def mark_as_read
		@notifications = unreader
		@notifications.update_all(read_at: Time.zone.now)
		render json: { success: true }
  end	

  private
    def unreader
      Notification.where(recipient: current_user).unread
    end
end

class NotificationsController < ApplicationController
	before_filter :authenticate_user!
	
	def index
		@notifications = Notification.where(recipient: current_user).unread
	end

	def mark_as_read
    # if params[:id]
    #   @notification = Notification.find(params[:id])
    #   @notification.update_attribute(read_at: Time.zone.now)
    # else
    #   @notifications = Notification.where(recipient: current_user).unread.update_all(read_at: Time.zone.now)
    #   #@notifications.update_all(read_at: Time.zone.now)
    # end

    # respond_to do |format|
    #   format.json { render json: { success: true } }
    # end    

		@notifications = Notification.where(recipient: current_user).unread
		@notifications.update_all(read_at: Time.zone.now)
		render json: { success: true }
  end	
end

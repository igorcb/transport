class NotificationsController < ApplicationController
  include ActionView::RecordIdentifier
	before_filter :authenticate_user!

	def index
    @notifications = unreader

    notifications_array = []
    @notifications.each do |notification|
      notifications_array.push({id: notification.id, recipient: notification.recipient.email, action: notification.action, actor: notification.actor.email, name: notification.notifiable.name, url: task_path(notification.notifiable, anchor: dom_id(notification.notifiable))})
    end
    respond_to do |format|
      format.html 
      format.json { render json: {notification: notifications_array}.to_json, content_type: 'application/json' }
    end    
	end

	def mark_as_read
		@notifications = unreader
    @notifications.update_all(read_at: Time.zone.now)
    respond_to do |format|
      format.json { render json: { success: true }.to_json, content_type: 'application/json' }
    end
  end	

  private
    def unreader
      Notification.where(recipient: current_user).unread
    end
end
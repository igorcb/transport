class Notification < ActiveRecord::Base
  belongs_to :recipient, class_name: 'User', required: false
  belongs_to :actor, class_name: 'User', required: false
  belongs_to :notifiable, polymorphic: true, required: false

  scope :unread, -> { where(read_at: nil) }
end

class Comment < ActiveRecord::Base
  #belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "comment_id", polymorphic: true, dependent: :destroy

  validates :content, presence: true

  def send_notification_email
  	CommentMailer.notification(self.ordem_service).deliver!
  end

  def ordem_service
  	OrdemService.find_by(id: self.comment_id)
  end
end

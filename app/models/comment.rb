class Comment < ActiveRecord::Base
  belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "comment_id", polymorphic: true, dependent: :destroy
	belongs_to :boarding, class_name: "Boarding", foreign_key: "comment_id", polymorphic: true, dependent: :destroy
  validates :content, presence: true

  def send_notification_email(model)
  	puts ">>>>>>>>>>>>>> send_notification_email. Model: #{model.class}"
  	result = model.class == Boarding
  	puts ">>>>>>>>>>>>>> result: #{result}"
    case model.class.to_s
      when "OrdemService" then CommentMailer.notification(ordem_service).deliver!
      when "Occurrence" then CommentMailer.notification(ordem_service).deliver!
      when "Boarding" then CommentMailer.notification_boarding(boarding).deliver!
    end
  end

  def ordem_service
  	OrdemService.find_by(id: self.comment_id)
  end

  def boarding
  	Boarding.find_by(id: self.comment_id)
  end
end

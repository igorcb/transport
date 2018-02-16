class InternalComment < ActiveRecord::Base
	#belongs_to :ordem_service, polymorphic: true, dependent: :destroy
	belongs_to :task, class_name: "Task", foreign_key: "comment_id", polymorphic: true, dependent: :destroy
	belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "comment_id", polymorphic: true, dependent: :destroy

	validates :content, presence: true
end

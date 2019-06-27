class InternalComment < ActiveRecord::Base
	#belongs_to :ordem_service, polymorphic: true, dependent: :destroy
	belongs_to :task, class_name: "Task", foreign_key: "comment_id", polymorphic: true, dependent: :destroy, required: false
	belongs_to :boarding, class_name: "Boarding", foreign_key: "comment_id", polymorphic: true, dependent: :destroy, required: false
	belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "comment_id", polymorphic: true, dependent: :destroy, required: false

	validates :content, presence: true
end

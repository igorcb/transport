class InternalComment < ActiveRecord::Base
	belongs_to :ordem_service, polymorphic: true, dependent: :destroy

	validates :content, presence: true
end

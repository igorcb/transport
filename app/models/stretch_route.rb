class StretchRoute < ActiveRecord::Base

	validates :stretch_source_id, presence: true
	validates :stretch_target_id, presence: true

	belongs_to :stretch_source, class_name: "Stretch", foreign_key: 'stretch_source_id'
	belongs_to :stretch_target, class_name: "Stretch", foreign_key: 'stretch_target_id'

end

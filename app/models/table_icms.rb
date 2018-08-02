class TableIcms < ActiveRecord::Base
	validates :state_source, presence: true, uniqueness: { scope: [:state_target] }
	validates :state_target, presence: true

	validates :aliquot, presence: true, numericality: { greater_than: 0 }
end

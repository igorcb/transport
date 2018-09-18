class TableInsurance < ActiveRecord::Base
  validates :insurer_id, presence: true
	validates :state_source, presence: true
	validates :state_target, presence: true
  validates :percent, presence: true, numericality: { greater_than: 0 }
	validates :state_target, uniqueness: { scope: :state_source }
	
  belongs_to :insurer
end

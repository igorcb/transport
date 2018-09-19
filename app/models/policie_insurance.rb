class PolicieInsurance < ActiveRecord::Base
  validates :insurer_id, presence: true
  validates :broker_id, presence: true
	validates :proposal, presence: true
	validates :policy, presence: true
  validates :date_start, presence: true
	validates :date_expired, presence: true
  validates :value, presence: true, numericality: { greater_than: 0 }
	#validates :state_target, uniqueness: { scope: :state_source }

  belongs_to :insurer
  belongs_to :broker

  module TypePolicie
  	RCTRC = 0 #'RCTR-C'
  	RCFV  = 1 #'RCF-V'
  end

  def type_policie_name
  	case self.type_policie.to_i
	  	when TypePolicie::RCTRC then "RCTR-C"
	  	when TypePolicie::RCFV  then "RCF-V"
	  end
  end
end

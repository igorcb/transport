class Activity < ActiveRecord::Base

  validates :descricao, presence: true, length: { maximum: 50 } 

  has_many :movement_activities
  has_many :suppliers, :through => :movement_activities
  #accepts_nested_attributes_for :movement_activities, allow_destroy: true, reject_if: :all_blank  	
end

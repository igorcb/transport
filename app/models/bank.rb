class Bank < ActiveRecord::Base
	
	validates :banco, presence: true, length: { maximum: 5 }, numericality: { only_integer: true }
  validates :nome, presence:true, length: { maximum: 60 }
end

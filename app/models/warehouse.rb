class Warehouse < ApplicationRecord
  has_many :deposit
  has_many :street , through: :deposit
  
  validates :name, :district, :state, :city, :zip_code, presence: true
  validates :address, presence: true, length: { minimum: 5 }
  validates :number, presence: true, length: { maximum: 10 }

end

class Antt < ActiveRecord::Base
	validates :rntrc, presence: true, numericality: { only_integer: true }
  validates :cpf_cnpj, presence:true
  validates :name, presence: true
  validates :date_expiration, presence: true

  has_and_belongs_to_many :vehicles

  has_many :antts_vehicles
end

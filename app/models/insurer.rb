class Insurer < ActiveRecord::Base
  validates :cnpj, presence: true
	validates :name, presence: true

	has_many :table_insurances
	has_many :policie_insurances
end

class Insurer < ActiveRecord::Base
  validates :cnpj, presence: true
	validates :name, presence: true

	has_many :table_insurances
	has_many :policie_insurances

	def policie_insurances_expired?
		Date.current > self.policie_insurances.ordered_expired.first.date_expired
	end
end

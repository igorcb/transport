class Shipper < ActiveRecord::Base
	validates :cnpj, presence: true, uniqueness: true
	validates :name, presence: true

	def cnpj_name
		"#{self.cnpj} - #{self.name}"
	end
end

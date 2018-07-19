class MicroRegion < ActiveRecord::Base
	has_many :micro_regions_cities

	def cities
		array = []
		self.micro_regions_cities.each do |city|
			array.append(city.city.name)
		end
		array
	end
end

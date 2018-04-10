class NatureFreight < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true	
end

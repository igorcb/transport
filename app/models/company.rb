class Company < ActiveRecord::Base
	
	def cidade_estado
    "#{self.cidade} '-' #{self.estado}"
	end
	
end

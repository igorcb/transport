class Stretch < ActiveRecord::Base
	validates :cidade, presence: true, length: { maximum: 20 }
	validates :estado, presence: true, length: { maximum: 2 }
	validates :destino, presence: true, length: { maximum: 3 }, uniqueness: true

	def description
		"#{self.estado} - #{self.cidade} - #{self.destino}	"
	end

end

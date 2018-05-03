class Stretch < ActiveRecord::Base
	validates :estado, presence: true, length: { maximum: 2 }
  validates :cidade, presence: true, uniqueness: {scope: :estado, case_sensitive: false}
	validates :destino, presence: true, length: { maximum: 3 }, uniqueness: true

	def description
		"#{self.estado} - #{self.cidade} - #{self.destino}	"
	end

end

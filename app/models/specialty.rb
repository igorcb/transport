class Specialty < ActiveRecord::Base
	validates :descricao, presence: true
end

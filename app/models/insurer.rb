class Insurer < ActiveRecord::Base
  validates :cnpj, presence: true
	validates :name, presence: true
end

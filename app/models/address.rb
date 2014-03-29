class Address < ActiveRecord::Base
	
	validates :tipo, presence: true
	validates :logradouro, presence: true
	validates :bairro, presence: true
	validates :cidade, presence: true
	validates :estado, presence: true
	validates :cep, presence: true, length: { maximum: 8 }, uniqueness: true

	#has_many :persons
	#has_one :client
  #accepts_nested_attributes_for :clients
end

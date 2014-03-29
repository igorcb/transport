class Person < ActiveRecord::Base
	validates :cpf_cnpj, presence: true, length: { maximum: 18 }, uniqueness: true
  validates :address_id, presence: true
	validates :nome, presence: true, length: { maximum: 100 }
	validates :fantasia, presence: true, length: { maximum: 100 }
	validates :numero, presence: true, length: { maximum: 15 }
	validates :complemento, length: { maximum: 100 }
	
	belongs_to :address
end


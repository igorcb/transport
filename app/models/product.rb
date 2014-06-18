class Product < ActiveRecord::Base
	validates :descricao, presence: true, length: { maximum: 100 } 
	validates :category_id, presence: true
	validates :cubagem, presence: true
	
	belongs_to :category

end

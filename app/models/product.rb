class Product < ActiveRecord::Base
	include UpdateOrCreate

	validates :descricao, presence: true, length: { maximum: 100 } 
	validates :category_id, presence: true
	validates :cubagem, presence: true
	
	belongs_to :category

  before_create do |item|
    item.cubagem = calc_cubagem
  end 

  def calculation_cubing
  	if (!height.nil?) || (!width.nil?) || (!length.nil?)
  	  (height / 100 ) * (width / 100) * (length / 100)
    end
  end

end

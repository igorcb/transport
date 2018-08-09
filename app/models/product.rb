class Product < ActiveRecord::Base
	#include UpdateOrCreate

	validates :descricao, presence: true, length: { maximum: 100 } 
	validates :category_id, presence: true
	validates :cubagem, presence: true
	
	belongs_to :category

  before_create do |item|
    item.cubagem = calculation_cubing
  end 

  def calculation_cubing
  	if (!height.nil?) || (!width.nil?) || (!length.nil?)
  	  (height / 100 ) * (width / 100) * (length / 100)
    end
  end

  def height_maximum_pallet
  	value = BigDecimal.new(0)
  	if (!height.nil?) || (!layer_pallet.nil?) 
  		value = (height * layer_pallet) / 100
   	end
   	value
  end

	def self.update_or_create(attributes)
	  assign_or_new(attributes).save
	end

	def self.assign_or_new(attributes)
	  obj = first || new
	  obj.assign_attributes(attributes)
	  obj
	end 

end

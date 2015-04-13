#require 'rmagick'
class CteKey < ActiveRecord::Base
  validates :cte, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }
  validates :chave, length: { is: 44 }, numericality: { only_integer: true }, allow_blank: true
	
	belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "cte_id", polymorphic: true, dependent: :destroy
  has_attached_file :asset
  validates_attachment_content_type :asset, :content_type => /\Aimage\/.*\Z/, allow_blank: true

  def is_image?
    return false unless asset.content_type
    ['image/jpeg', 'image/jpg'].include?(asset.content_type)
  end  
  
  def tesseract_context?
    #%w('CT-e', 'CT-E', 'CTE', 'CTe').each {|str| puts str}
    img = RTesseract.new(self.asset.path)
    text_img = img.to_s
    text_img.include?(self.cte) ? true : false
  end

end

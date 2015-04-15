class NfeKey < ActiveRecord::Base
  validates :nfe, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }
  #validates :chave, presence: true, length: { is: 44 }, numericality: { only_integer: true }
  validates :chave, length: { is: 44 }, numericality: { only_integer: true }, allow_blank: true
	
	belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "nfe_id", polymorphic: true, dependent: :destroy

  has_attached_file :asset
  validates_attachment_content_type :asset, :content_type => /\Aimage\/.*\Z/, allow_blank: true

  def is_image?
    return false unless asset.content_type
    ['image/jpeg', 'image/jpg'].include?(asset.content_type)
  end  
  
  def tesseract_context?
    #%w('CT-e', 'CT-E', 'CTE', 'CTe').each {|str| puts str}
    if self.asset.present?
      img = RTesseract.new(self.asset.path)
      puts ">>>>>>>>>>>>> Img: #{img.to_s}"
      text_img = img.to_s
      text_img.include?(self.nfe) ? true : false
    end
  end

end

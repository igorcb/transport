#require 'rmagick'
class CteKey < ActiveRecord::Base
  validates :cte, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }
  validates :chave, length: { is: 44 }, numericality: { only_integer: true }, allow_blank: true
	
	belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "cte_id"
  has_attached_file :asset
  validates_attachment_content_type :asset, :content_type => /\Aimage\/.*\Z/, allow_blank: true

  has_many :cancellations, class_name: "Cancellation", foreign_key: "cancellation_id", :as => :cancellation, dependent: :destroy
  accepts_nested_attributes_for :cancellations, allow_destroy: true, :reject_if => :all_blank

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
      text_img.include?(self.cte) ? true : false
    end
  end

  def self.ordem_service(id)
    puts " >>>>>>>>>>>>>> ID: #{id}"
    cte = CteKey.find(id)
    cte.ordem_service
  end

end

class NfeKey < ActiveRecord::Base
  validates :nfe, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }
  validates :chave, length: { is: 44 }, numericality: { only_integer: true }, allow_blank: true
	
	belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "nfe_id", dependent: :destroy#, polymorphic: true
  belongs_to :pallet, class_name: "Pallet", foreign_key: "nfe_id", dependent: :destroy #, polymorphic: true

  has_attached_file :asset, :styles => {medium: "300x300>", thumb: "100x100>", mini: "32x32>"}
  # has_attached_file :asset,
  # :styles => {:medium => "300x300>", :thumb => "100x100>"},
  # :url => "assets/:class/:attachment/:id/:style/:basename.:extension",
  # :path => ":rails_root/assets/:class/:attachment/:id/:style/:basename.:extension"   
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

  def self.ransackable_attributes(auth_object = nil)
    ['nfe']
  end

  # def input_control

  # end


end

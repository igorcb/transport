#require 'rmagick'
class CteKey < ActiveRecord::Base
  validates :cte, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }
  validates :chave, length: { is: 44 }, numericality: { only_integer: true }, allow_blank: true

	belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "cte_id", required: false
  has_attached_file :asset
  validates_attachment_content_type :asset, :content_type => /\Aimage\/.*\Z/, allow_blank: true

  has_many :cancellations, class_name: "Cancellation", foreign_key: "cancellation_id", :as => :cancellation, dependent: :destroy
  accepts_nested_attributes_for :cancellations, allow_destroy: true, :reject_if => :all_blank

  before_save :check_all_cte_canceled?

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

  def check_all_cte_canceled?
    positivo = true
    ordem_service = self.ordem_service
    ordem_service.cte_keys.each  do |cte|
      if cte.cancellations.first.present?
        positivo = cte.cancellations.first.status == Cancellation::TipoStatus::CONFIRMADO
        if positivo == false
          errors.add(:ordem_service, "you can not include CT-e while it is not canceled")
          return false
        end
      else
        positivo == false
        errors.add(:ordem_service, "you can not include CT-e while it is not canceled")
        return false
      end
    end
    positivo
  end

end

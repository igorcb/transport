class NfsKey < ActiveRecord::Base
  validates :nfs, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }
  validates :chave, numericality: { only_integer: false }, allow_blank: true

	belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "nfs_id", dependent: :destroy, required: false

  has_many :cancellations, class_name: "Cancellation", foreign_key: "cancellation_id", :as => :cancellation, dependent: :destroy
  accepts_nested_attributes_for :cancellations, allow_destroy: true, :reject_if => :all_blank

  def self.ordem_service(id)
  	puts " >>>>>>>>>>>>>> ID: #{id}"
  	nfs = NfsKey.find(id)
  	nfs.ordem_service
  end

end

class NfsKey < ActiveRecord::Base
  validates :nfs, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }
  validates :chave, length: { is: 44 }, numericality: { only_integer: true }, allow_blank: true
	
	belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "nfs_id", polymorphic: true, dependent: :destroy
end

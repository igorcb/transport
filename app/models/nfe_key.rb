class NfeKey < ActiveRecord::Base
  validates :nfe, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }
  validates :chave, presence: true, length: { is: 44 }, numericality: { only_integer: true }
	
	belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "nfe_id", polymorphic: true, dependent: :destroy
end

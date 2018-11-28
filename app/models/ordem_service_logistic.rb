class OrdemServiceLogistic < ActiveRecord::Base
  belongs_to :ordem_service, required: false

  validates :driver_id, presence: true
  validates :placa, presence: true, length: { maximum: 10 }
  # validates :cte, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }, uniqueness: true
  # validates :danfe_cte, length: { is: 44 }, numericality: { only_integer: true }, uniqueness: true

  belongs_to :driver, required: false
  belongs_to :delivery_driver, class_name: "Driver", foreign_key: 'delivery_driver_id', required: false

  before_save { |os| os.placa = placa.upcase }
end

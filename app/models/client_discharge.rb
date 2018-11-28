class ClientDischarge < ActiveRecord::Base
  validates :client_id, presence: true
  validates :client_source_id, presence: true
  validates :type_unit, presence: true
  validates :type_charge, presence: true
  validates :type_calc, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :client_source_id, uniqueness: { scope: [:client_id, :type_unit, :type_charge, :type_calc],
                                           message: ": tabela de descagar com tipo de unidade, tipo de carga, tipo de calculo já estão em uso. "}

  belongs_to :client, required: false
  belongs_to :client_source, class_name: "Client", foreign_key: :client_source_id, required: false

  belongs_to :created_user, class_name: "User", foreign_key: :created_user_id, required: false
  belongs_to :updated_user, class_name: "User", foreign_key: :updated_user_id, required: false

  #scope :type_box_palletized_unit, -> { where(type_unit: TypeUnit::BOX, type_charge: TypeCharge::PALLETIZED, type_calc: TypeCalc::UNIT).first }
  #scope :type_box_palletized_value, -> { where(type_unit: TypeUnit::BOX, type_charge: TypeCharge::PALLETIZED, type_calc: TypeCalc::VALUE).first }

  module TypeUnit
  	BOX = 0
  	BURDEN = 1
  	TAMBO = 2
  	BIG_BAG = 3
  end

  module TypeCharge
		PALLETIZED = 0
		SLAM = 1
		MIXED = 2
		ADJUSTED = 3
  end

  module TypeCalc
  	WEIGHT = 0
  	UNIT = 1
  	VALUE = 2
  end

  def type_unit_name
  	case self.type_unit
  		when TypeUnit::BOX then "Caixaria"
  		when TypeUnit::BURDEN then "Fardo"
  		when TypeUnit::TAMBO then "Tambor"
  		when TypeUnit::BIG_BAG then "Big Bag"
  	end
  end

  def type_charge_name
  	case self.type_charge
  		when TypeCharge::PALLETIZED then "Paletizada"
  		when TypeCharge::SLAM then "Batida"
  		when TypeCharge::MIXED then "Mista"
  		when TypeCharge::ADJUSTED then "Acertado"
  	end
  end

  def type_calc_name
  	case self.type_calc
  		when TypeCalc::WEIGHT then "Peso"
  		when TypeCalc::UNIT   then "Unidade"
  		when TypeCalc::VALUE  then "Valor"
  	end
  end

  # def self.type_box_palletized_weight(params = {})
  #   if params[:client_id].present? && params[:client_source_id].present?
  #     ClientDischarge.where(client_id: params[:client_id],
  #                  client_source_id: params[:client_source_id],
  #                         type_unit: params[:type_unit], #TypeUnit::BOX,
  #                       type_charge: TypeCharge::PALLETIZED,
  #                         type_calc: TypeCalc::WEIGHT).first
  #   end
  # end

  # def self.type_box_palletized_unit(params = {})
  #   if params[:client_id].present? && params[:client_source_id].present?
  #     ClientDischarge.where(client_id: params[:client_id],
  #                  client_source_id: params[:client_source_id],
  #                         type_unit: TypeUnit::BOX,
  #                       type_charge: TypeCharge::PALLETIZED,
  #                         type_calc: TypeCalc::UNIT).first
  #   end
  # end

  # def self.type_box_palletized_value(params = {})
  #   if params[:client_id].present? && params[:client_source_id].present?
  #     ClientDischarge.where(client_id: params[:client_id],
  #                  client_source_id: params[:client_source_id],
  #                         type_unit: TypeUnit::BOX,
  #                       type_charge: TypeCharge::PALLETIZED,
  #                         type_calc: TypeCalc::VALUE).first
  #   end
  # end

  # def self.type_box_slam_weight(params = {})
  #   if params[:client_id].present? && params[:client_source_id].present?
  #     ClientDischarge.where(client_id: params[:client_id],
  #                  client_source_id: params[:client_source_id],
  #                         type_unit: TypeUnit::BOX,
  #                       type_charge: TypeCharge::SLAM,
  #                         type_calc: TypeCalc::WEIGHT).first
  #   end
  # end

  # def self.type_box_slam_unit(params = {})
  #   if params[:client_id].present? && params[:client_source_id].present?
  #     ClientDischarge.where(client_id: params[:client_id],
  #                  client_source_id: params[:client_source_id],
  #                         type_unit: TypeUnit::BOX,
  #                       type_charge: TypeCharge::SLAM,
  #                         type_calc: TypeCalc::UNIT).first
  #   end
  # end

  # def self.type_box_slam_value(params = {})
  #   if params[:client_id].present? && params[:client_source_id].present?
  #     ClientDischarge.where(client_id: params[:client_id],
  #                  client_source_id: params[:client_source_id],
  #                         type_unit: TypeUnit::BOX,
  #                       type_charge: TypeCharge::SLAM,
  #                         type_calc: TypeCalc::VALUE).first
  #   end
  # end

  def calc_weight(weight)
    (self.price / 1000) * weight
  end

  def calc_unit(units)
    units ||= 0
    self.price  * units
  end

  def calc_volume(volume)
    volume ||= 0
    self.price  * volume
  end
end

# discharge = ClientDischarge.where(client_id: 116,
#                client_source_id: 260,
#                       type_unit: ClientDischarge::TypeUnit::BOX,
#                     type_charge: ClientDischarge::TypeCharge::PALLETIZED,
#                       type_calc: ClientDischarge::TypeCalc::WEIGHT)

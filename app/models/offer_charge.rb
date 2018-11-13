class OfferCharge < ActiveRecord::Base
  validates :shipper, presence: true
  validates :date_shipment, presence: true
	validates :shipping, presence: true, uniqueness: true
	validates :local_loading, presence: true
  validates :type_vehicle, presence: true

  belongs_to :user
	has_one :direct_charge

	has_many :offer_items
  accepts_nested_attributes_for :offer_items, allow_destroy: true, :reject_if => :all_blank

	has_many :offer_drivers
  accepts_nested_attributes_for :offer_drivers, allow_destroy: true, :reject_if => :all_blank

  has_one :cancellation, class_name: "Cancellation", foreign_key: "cancellation_id"
  has_many :cancellations, class_name: "Cancellation", foreign_key: "cancellation_id", :as => :cancellation, dependent: :destroy
  accepts_nested_attributes_for :cancellations, allow_destroy: true, :reject_if => :all_blank

	before_save do |offer|
		offer.shipper = offer.shipper.upcase
		offer.shipping = offer.shipping.upcase
		offer.local_loading = offer.local_loading.upcase
		offer.type_vehicle = offer.type_vehicle.upcase
		offer.vehicle_detail = offer.vehicle_detail.upcase
	end

	before_create do |offer|
		offer.vehicle_situation = '0'
		offer.status = TypeStatus::OPEN
	end

	scope :only_open, -> { where(status: TypeStatus::OPEN).order(date_shipment: :desc, id: :desc) }
	#scope :reordered, -> { order(date_shipment: :desc, id: :desc) }

	module TypeStatus
		OPEN = 0
		CLOSE = 1
		CANCEL = 2
	end

	def vehicle_situation_name
		case vehicle_situation
			when 0 then "Aguardando"
			when 1 then "Confirmado"
			when 2 then "Rejeitado"
			when 3 then "No Show"
		end
	end

	def status_name
		case status
			when 0 then "Aberto"
			when 1 then "Fechado"
			when 2 then "Cancelado"
		end
	end

  def palletized_status
    case self.palletized
      when false then "Nao"
      when true then "Sim"
      else "Nao Informado"
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ['shipper', 'shipping', 'date_shipment', 'vehicle_situation', 'status']
  end

	def qtde_pallets
		self.offer_items.sum(:qtde_pallets).to_i
	end

	def weight
		self.offer_items.sum(:weight).to_f
	end

	def volume
		self.offer_items.sum(:volume).to_f
	end

  def feed_cancellations
    Cancellation.where("cancellation_type = ? and cancellation_id = ?", "OfferCharge", self.id)
  end

end

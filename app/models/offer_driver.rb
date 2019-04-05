class OfferDriver < ActiveRecord::Base
	validates :offer_charge, presence: true
	validates :user_id, presence: true
  validates :driver, presence: true
  validates :date_incoming, presence: true
  validates :type_vehicle, presence: true
	validates :place_horse, presence: true, length: { maximum: 8 }
	validates :observation, length: { minimum: 15 }, if: Proc.new {|c| not c.observation.blank?}
  #validates :place_cart_first, length: { maximum: 8 } if: lambda { |d| d.place_cart_first.present? }
  #validates :place_cart_second, length: { maximum: 8 } if: Proc.new { |d| d.place_cart_second.present? }
  #validates :status, presence: true
	#validates_uniqueness_of :status, conditions: -> { where(status: TypeStatus::WAITING) }

  belongs_to :offer_charge, required: false
  belongs_to :user, required: false

 	before_create do |offer|
 		offer.driver = offer.driver.upcase
 		offer.type_vehicle = offer.type_vehicle.upcase
 		offer.place_horse = offer.place_horse.upcase
 		offer.place_cart_first = offer.place_cart_first.upcase
 		offer.place_cart_second = offer.place_cart_second.upcase
		offer.status = TypeStatus::WAITING
	end

	#before_save :normalize_card_number, if: :paid_with_card?
	#before_save :if_not_waiting, :if => Proc.new {|offer_driver| offer_driver.if_not_waiting? }

	scope :waiting, -> { where(status: TypeStatus::WAITING) }
	scope :waiting_or_confirmed, -> { where(status: [TypeStatus::WAITING, TypeStatus::CONFIRMED]) }

	module TypeStatus
		WAITING   = 0
		CONFIRMED = 1
		REJECT    = 2
		NOSHOW    = 3
		NONSUIT   = 4
	end

	def status_name
		case status
			when 0 then "Aguardando"
			when 1 then "Confirmado"
			when 2 then "Rejeitado"
			when 3 then "No Show"
			when 4 then "Desistência"
		end
	end

	def self.confirmed(offer_driver)
    ActiveRecord::Base.transaction do
    	OfferDriver.where(id: offer_driver.id).update_all(status: TypeStatus::CONFIRMED)
      OfferCharge.where(id: offer_driver.offer_charge.id).update_all(vehicle_situation: TypeStatus::CONFIRMED ,status: OfferCharge::TypeStatus::CLOSE)
    end
	end

	def self.reject(offer_driver)
    # ActiveRecord::Base.transaction do
    # 	OfferDriver.where(id: offer_driver.id).update_all(status: TypeStatus::REJECT)
    #   OfferCharge.where(id: offer_driver.offer_charge.id).update_all(status: OfferCharge::TypeStatus::OPEN)
    # end
		begin
      ActiveRecord::Base.transaction do
    	  OfferDriver.where(id: offer_driver.id).update_all(status: TypeStatus::REJECT)
        OfferCharge.where(id: offer_driver.offer_charge.id).update_all(status: OfferCharge::TypeStatus::OPEN)
        return true
      end
      rescue Exception => e
        puts e.message
        self.errors.add(:offer_driver, e.message)
        return false
    end
	end

	def self.noshow(offer_driver)
    ActiveRecord::Base.transaction do
    	OfferDriver.where(id: offer_driver.id).update_all(status: TypeStatus::NOSHOW)
      OfferCharge.where(id: offer_driver.offer_charge.id).update_all(status: OfferCharge::TypeStatus::OPEN)
    end
	end

	def self.nonsuit(offer_driver)
    ActiveRecord::Base.transaction do
    	OfferDriver.where(id: offer_driver.id).update_all(status: TypeStatus::NONSUIT)
      OfferCharge.where(id: offer_driver.offer_charge.id).update_all(status: OfferCharge::TypeStatus::OPEN)
    end
	end

	def waiting_or_confirmed_status?
		(self.status == TypeStatus::WAITING) or (self.status == TypeStatus::CONFIRMED)
	end
end

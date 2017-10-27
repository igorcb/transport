class OfferDriver < ActiveRecord::Base
	validates :offer_charge, presence: true
	validates :user_id, presence: true
  validates :driver, presence: true
  validates :date_incoming, presence: true
  validates :type_vehicle, presence: true
	validates :place_horse, presence: true, length: { maximum: 8 }  
  #validates :place_cart_first, length: { maximum: 8 } if: lambda { |d| d.place_cart_first.present? }
  #validates :place_cart_second, length: { maximum: 8 } if: Proc.new { |d| d.place_cart_second.present? }
  #validates :status, presence: true

  belongs_to :offer_charge
  belongs_to :user

 	before_create do |offer|
 		offer.driver = offer.driver.upcase
 		offer.type_vehicle = offer.type_vehicle.upcase
 		offer.place_horse = offer.place_horse.upcase
 		offer.place_cart_first = offer.place_cart_first.upcase
 		offer.place_cart_second = offer.place_cart_second.upcase
		offer.status = TypeStatus::WAITING
	end

	module TypeStatus
		WAITING = 0
		ACEITE  = 1
		REJECT  = 2
		NOSHOW  = 3
		NONSUIT = 4
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
end

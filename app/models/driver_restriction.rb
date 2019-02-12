class DriverRestriction < ActiveRecord::Base
	validates :client_id, presence: true
	validates :restriction, presence: true

	belongs_to :driver, required: false
  belongs_to :client, required: false

	enum restriction: { charge: 0, client: 1, security: 2, carrier: 3 }
	enum status: { locking: 0, unlocking: 1 }

	before_save do |v|
    v.status = 0
  end

	def self.driver_loking?(driver_id)
    DriverRestriction.locking.where(driver_id: driver_id).present?
  end

	def self.unlock(driver_id)
    DriverRestriction.where(id: driver_id.id).update_all(status: 1)
  end
end

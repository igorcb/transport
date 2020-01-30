class Devolution < ApplicationRecord
  validates :carrier_id, :driver_id, :billing_client_id, presence: true
	validates :place, :place_horse, :place_cart_1, :date_entry, :time_entry, presence: true


  belongs_to :carrier, required: false
  belongs_to :driver, required: false
  belongs_to :billing_client, class_name: "Client", foreign_key: "billing_client_id", required: false
  belongs_to :user, required: false
  belongs_to :breakdown_received, class_name: "User", foreign_key: "breakdown_user_id", required: false
  belongs_to :user_received, class_name: "User", foreign_key: "received_user_id", required: false
  belongs_to :started_user, class_name: "User", foreign_key: "started_user_id", required: false
  belongs_to :billing_client, class_name: "Client", foreign_key: "billing_client_id", required: false


end

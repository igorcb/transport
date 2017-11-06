class ClientRepresentative < ActiveRecord::Base
	validates :client_id, presence: true
	validates :representative_id, presence: true
	validates :billing_client_id, presence: true, uniqueness: {scope: :client_id}

  belongs_to :client
  belongs_to :representative
  belongs_to :billing_client, class_name: "Client", foreign_key: 'billing_client_id'
end

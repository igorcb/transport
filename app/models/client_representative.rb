class ClientRepresentative < ActiveRecord::Base
	validates :client_id, presence: true, uniqueness: {scope: :representative_id}
	validates :representative_id, presence: true, uniqueness: {scope: :client_id}

  belongs_to :client
  belongs_to :representative
end

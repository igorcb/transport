class ClientRepresentative < ActiveRecord::Base
  belongs_to :client
  belongs_to :representative
end

class ClientsPallet < ActiveRecord::Base
  belongs_to :client
  belongs_to :product

  belongs_to :source_client, class_name: "Client", foreign_key: :source_client_id

end

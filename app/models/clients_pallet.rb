class ClientsPallet < ActiveRecord::Base
  belongs_to :client, required: false
  belongs_to :product, required: false

  belongs_to :source_client, class_name: "Client", foreign_key: :source_client_id, required: false

end

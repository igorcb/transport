class CarrierCredential < ActiveRecord::Base
  belongs_to :carrier_source, class_name: "Carrier", foreign_key: "carrier_source_id", required: false
  belongs_to :carrier_credential, class_name: "Carrier", foreign_key: "carrier_credential_id", required: false

end

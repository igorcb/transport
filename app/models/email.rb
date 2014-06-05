class Email < ActiveRecord::Base

  belongs_to :carrier, class_name: "Carrier", foreign_key: "contact_id", polymorphic: true, dependent: :destroy
  belongs_to :client, class_name: "Client", foreign_key: "contact_id", polymorphic: true, dependent: :destroy
  belongs_to :owner, class_name: "Owner", foreign_key: "contact_id", polymorphic: true, dependent: :destroy
  belongs_to :supplier, class_name: "Supplier", foreign_key: "contact_id", polymorphic: true, dependent: :destroy

end

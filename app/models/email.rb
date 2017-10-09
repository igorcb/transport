class Email < ActiveRecord::Base
	belongs_to :sector
  belongs_to :carrier, class_name: "Carrier", foreign_key: "contact_id", polymorphic: true, dependent: :destroy
  belongs_to :client, class_name: "Client", foreign_key: "contact_id", polymorphic: true, dependent: :destroy
  belongs_to :owner, class_name: "Owner", foreign_key: "contact_id", polymorphic: true, dependent: :destroy
  belongs_to :supplier, class_name: "Supplier", foreign_key: "contact_id", polymorphic: true, dependent: :destroy
  
  scope :type_sector, -> sector { where(sector_id: sector) }
  #scope :balance_day, -> date {where(date_ocurrence: date).order(date_ocurrence: :desc, id: :desc) }
end

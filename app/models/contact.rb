class Contact < ActiveRecord::Base
  validates :tipo, presence: true
  validates :nome, presence: true,  length: { maximum: 30 }
  #validates :fone, presence: true
  #validates :contact_id, presence: true
  #validates :contact_type, presence: true

  belongs_to :client, class_name: "Client", foreign_key: "contact_id", polymorphic: true, dependent: :destroy
  belongs_to :driver, class_name: "Driver", foreign_key: "contact_id", polymorphic: true, dependent: :destroy
  belongs_to :employee, class_name: "Employee", foreign_key: "contact_id", polymorphic: true, dependent: :destroy
  belongs_to :supplier, class_name: "Supplier", foreign_key: "contact_id", polymorphic: true, dependent: :destroy
  belongs_to :carrier, class_name: "Carrier", foreign_key: "contact_id", polymorphic: true, dependent: :destroy
  
	module TipoContato
		FIXO     = 0
		CELULAR  = 1
		EMAIL    = 2
		TWITTER  = 3
		FACEBOOK = 4
	end

	def tipo_contato
		case self.tipo
		  when 0 then "Fixo"
		  when 1 then "Celular"
		  when 2 then "Email"
			when 3 then "Twitter"
			when 4 then "Facebook"
		end
		
	end

end

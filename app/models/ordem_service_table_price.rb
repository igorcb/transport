class OrdemServiceTablePrice < ActiveRecord::Base
  belongs_to :ordem_service, required: false
  belongs_to :type_service, required: false
  belongs_to :stretch_route, required: false
  belongs_to :client_table_price, required: false
  belongs_to :ordem_service_type_service, required: false

	def self.update_or_create(attributes)
	  assign_or_new(attributes).save
	end

	def self.assign_or_new(attributes)
	  obj = first || new
	  obj.assign_attributes(attributes)
	  obj
	end
end

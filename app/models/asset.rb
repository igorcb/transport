class Asset < ActiveRecord::Base
	belongs_to :carrier, class_name: "Carrier", foreign_key: "asset_id", polymorphic: true, dependent: :destroy
	belongs_to :client, class_name: "Client", foreign_key: "asset_id", polymorphic: true, dependent: :destroy
	belongs_to :driver, class_name: "Driver", foreign_key: "asset_id", polymorphic: true, dependent: :destroy
	belongs_to :vehicle, class_name: "Vehicle", foreign_key: "asset_id", polymorphic: true, dependent: :destroy
	belongs_to :employee, class_name: "Employee", foreign_key: "asset_id", polymorphic: true, dependent: :destroy
	belongs_to :supplier, class_name: "Supplier", foreign_key: "asset_id", polymorphic: true, dependent: :destroy
	belongs_to :operating, class_name: "Operating", foreign_key: "asset_id", polymorphic: true, dependent: :destroy
    has_attached_file :asset, styles: lambda { |a| a.instance.asset_content_type =~ %r(image) ? { medium: "300x300>", thumb: "120x90>", mini: "64x64>"} : {} }

	def is_image?
	  return false unless asset.content_type
	  ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png', 'image/jpg'].include?(asset.content_type)
	end  
end


# @@doc_types = {
# :image => ['image/jpg','image/jpeg','image/pjpeg','image/png','image/x-png','image/gif'],
# :pdf => ['application/pdf'],
# :word => ['application/msword','applicationvnd.ms-word','applicaiton/vnd.openxmlformats-officedocument.wordprocessingm1.document'],
# :excel => ['application/msexcel','application/vnd.ms-excel','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'],
# :powerpoint => ['application/mspowerpoint','application/vnd.ms-powerpoint','application/vnd.openxmlformats-officedocument.presentationml.presentation'],
# :text => ['text/plain']

# }
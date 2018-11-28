class OperatingService < ActiveRecord::Base
  #belongs_to :operating, class_name: "Operating", foreign_key: "asset_id", polymorphic: true, dependent: :destroy

  belongs_to :operating, required: false
  belongs_to :type_service, required: false

end

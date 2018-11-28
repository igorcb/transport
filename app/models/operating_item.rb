class OperatingItem < ActiveRecord::Base
  belongs_to :operating, required: false
  belongs_to :product, required: false
end

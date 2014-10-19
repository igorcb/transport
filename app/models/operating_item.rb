class OperatingItem < ActiveRecord::Base
  belongs_to :operating
  belongs_to :product
end

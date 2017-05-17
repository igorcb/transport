class ItemInputControl < ActiveRecord::Base
  belongs_to :input_control
  belongs_to :product
end

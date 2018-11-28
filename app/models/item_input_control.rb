class ItemInputControl < ActiveRecord::Base
  belongs_to :input_control, required: false
  belongs_to :product, required: false
end

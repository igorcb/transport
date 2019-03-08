class ItemInputControl < ActiveRecord::Base
  belongs_to :input_control, required: true
  belongs_to :product, required: true
  validates :number_nfe, presence: true
end

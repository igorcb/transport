class Palletizing < ApplicationRecord
  belongs_to :input_control_id

  enum view_mode: [:by_customer, :by_nfe, :single]
end

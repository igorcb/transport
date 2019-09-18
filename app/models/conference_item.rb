class ConferenceItem < ApplicationRecord
  belongs_to :conference
  belongs_to :product
end

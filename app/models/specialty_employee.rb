class SpecialtyEmployee < ActiveRecord::Base
  belongs_to :specialty, required: false
  belongs_to :employee, required: false

  validates :specialty_id, presence: true
  validates :valor, presence: true
end

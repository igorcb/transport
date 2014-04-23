class SpecialtyEmployee < ActiveRecord::Base
  belongs_to :specialty
  belongs_to :employee

  validates :specialty_id, presence: true
  validates :valor, presence: true
end

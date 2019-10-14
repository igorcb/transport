class ConferenceBreakdown < ApplicationRecord
  belongs_to :conference
  belongs_to :product

  def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end
  
end

class Conference < ApplicationRecord
  belongs_to :user
  belongs_to :input_control, class_name: "InputControl", foreign_key: "conference_id", polymorphic: true, dependent: :destroy, required: false
  has_many :conference_items

end

#input_control.conferences.create()

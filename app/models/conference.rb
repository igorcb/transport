class Conference < ApplicationRecord
  belongs_to :user
  # belongs_to :input_control, class_name: "InputControl", foreign_key: "conference_id", polymorphic: true, dependent: :destroy, required: false
  has_many :conference_items, dependent: :destroy
  has_many :conference_breakdowns, dependent: :destroy

  enum type_operation: [:input_control, :boarding]
  enum status: {start: "0", finish: "1"}
  enum approved: {waiting: "0", yes: "1", not: "2"}
  #enum status: ["start", "finish"]

  def input_control
    InputControl.where(id: self.conference_id).first if self.conference_type == "InputControl"
  end
end

#input_control.conferences.create()

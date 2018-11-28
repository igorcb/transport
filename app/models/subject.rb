class Subject < ActiveRecord::Base
  belongs_to :meeting, required: false

  has_many :subject_answers
end

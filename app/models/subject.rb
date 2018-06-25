class Subject < ActiveRecord::Base
  belongs_to :meeting

  has_many :subject_answers
end

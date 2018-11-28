class SubjectAnswer < ActiveRecord::Base
  belongs_to :subject, required: false
end

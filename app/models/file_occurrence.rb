class FileOccurrence < ActiveRecord::Base
  belongs_to :client

  has_many :occurrences
end

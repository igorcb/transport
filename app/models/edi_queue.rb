class EdiQueue < ApplicationRecord
  belongs_to :nfe_key
  #enum status: [:active, :archived], _suffix: true
  enum status: {not_proccess: 0, proccess: 2}
end

class PalletizingLog < ApplicationRecord

  enum type_log: [:input, :output]

end

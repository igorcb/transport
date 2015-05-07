class LowerAccountReceivable < ActiveRecord::Base
  belongs_to :account_receivable
  belongs_to :cash_account
end

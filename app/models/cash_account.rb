class CashAccount < ActiveRecord::Base
  belongs_to :bank
  validates :nome, presence: true, length: {maximum: 100} 
  validates :ted_doc, presence: true

  has_many :account_payables
end

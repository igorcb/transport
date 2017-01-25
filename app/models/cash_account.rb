class CashAccount < ActiveRecord::Base
  belongs_to :bank
  validates :nome, presence: true, length: {maximum: 100} 
  validates :ted_doc, presence: true

  has_many :account_payables

  module TipoLancamento
    CREDITO = 1
    DEBITO  = -1
  end
  
  def saldo
  	Cash.where(cash_account_id: self.id).sum('valor*tipo')
  end
end

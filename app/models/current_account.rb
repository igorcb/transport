class CurrentAccount < ActiveRecord::Base
  validates :cash_account_id, presence: true
  validates :data, presence: true
  validates :valor, presence: true
  validates :tipo, presence: true
  validates :historico, presence: true

  belongs_to :cash_account
  has_many :account_payables

  module TipoLancamento
    CREDITO = 1
    DEBITO  = -1
  end
  
  def credito_debito
  	case self.tipo
  		when -1 then "Débito"
  		when  1	then "Crédito"
  		else ""
  	end
  end
end

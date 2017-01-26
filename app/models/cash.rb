class Cash < ActiveRecord::Base
  validates :data, presence: true
  validates :valor, presence: true
  validates :tipo, presence: true
  
  validates :payment_method, presence: true
  validates :cost_center, presence: true
  validates :sub_cost_center, presence: true

  belongs_to :account_payable
  belongs_to :cash_account

  belongs_to :payment_method
  belongs_to :cost_center
  belongs_to :sub_cost_center
  belongs_to :sub_cost_center_three

  module TipoLancamento
    CREDITO = 1
    DEBITO  = -1
  end
  
  def credito_debito
  	case self.tipo
  		when  1	then "Crédito"
  		when -1 then "Débito"
  		else ""
  	end
  end  

  def self.ransackable_attributes(auth_object = nil)
    ['data',  "cash_account_id"]
  end

end

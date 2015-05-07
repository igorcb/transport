class AccountReceivable < ActiveRecord::Base
  validates :client_id, presence: true
  validates :cost_center_id, presence: true
  validates :sub_cost_center_id, presence: true
  validates :historic_id, presence: true
  validates :documento, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }
  validates :data_vencimento, presence: true
  validates :valor, presence: true, numericality: { greater_than: 0 }

  belongs_to :client
  belongs_to :cost_center
  belongs_to :sub_cost_center
  belongs_to :historic
  belongs_to :ordem_service

  #has_many :lower_account_payables

  def status_name
    case self.status
      when 0  then "Aberto"
      when 1  then "P. Parcial"
      when 2  then "Pago"
    else "Nao Definido"
    end
  end 

  def total_pago
    #self.lower_account_payables.sum(:total_pago)
    0.00
  end

  def saldo
    valor #- self.lower_account_payables.sum(:valor_pago)
  end

end

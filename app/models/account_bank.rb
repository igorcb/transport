class AccountBank < ActiveRecord::Base
  
  #belongs_to :bank, class_name: "Account", foreign_key: "account_id", polymorphic: true, dependent: :destroy
  belongs_to :driver, class_name: "Driver", foreign_key: "account_id", polymorphic: true, dependent: :destroy
  belongs_to :client, class_name: "Client", foreign_key: "account_id", polymorphic: true, dependent: :destroy
  belongs_to :carrier, class_name: "Carrier", foreign_key: "account_id", polymorphic: true, dependent: :destroy
  belongs_to :employee, class_name: "Employee", foreign_key: "account_id", polymorphic: true, dependent: :destroy
  belongs_to :supplier, class_name: "Supplier", foreign_key: "account_id", polymorphic: true, dependent: :destroy
  belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "account_id", polymorphic: true, dependent: :destroy

  before_save :select_bank

  module TipoOperacao
    CONTA_CORRENTE = 0
    CONTA_POUPANCA = 1
    CONTA_SALARIO  = 2
  end

  def nome_tipo_operacao
    case self.tipo_operacao
      when 0  then "Conta Corrente"
      when 1  then "Conta Poupança"
      when 2  then "Conta Salario"
    else "Nao Definido"
    end
  end

  def select_bank
  	bank = Bank.find (self.banco)
  	self.nome_banco = bank.nome
  end

  def cod_banco
    if self.banco.to_i == 0
      "Nao Definido"
    else  
  	  bank = Bank.where(id: self.banco).first
  	  bank.present? ? bank.banco : 0
    end
  end
end

class AccountBank < ActiveRecord::Base
  
  #belongs_to :bank, class_name: "Account", foreign_key: "account_id", polymorphic: true, dependent: :destroy
  belongs_to :driver, class_name: "Driver", foreign_key: "account_id", polymorphic: true, dependent: :destroy
  belongs_to :client, class_name: "Client", foreign_key: "account_id", polymorphic: true, dependent: :destroy

  before_save :select_bank
  

  def select_bank
    puts ">>>>>>>>>>>>>>>>>>>>>>> #{self.banco}"
  	bank = Bank.find (self.banco)
  	self.nome_banco = bank.nome
  end

  def cod_banco
  	bank = Bank.find (self.banco)
  	bank.banco
  end
end

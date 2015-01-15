class Bank < ActiveRecord::Base
	
	validates :banco, presence: true, length: { maximum: 5 }, numericality: { only_integer: true }
  validates :nome, presence:true, length: { maximum: 60 }
  has_many :cash_accounts
  
  def nome_completo
  	self.banco + ' - ' + self.nome
  end

end

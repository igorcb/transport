class ControlPallet < ActiveRecord::Base
  belongs_to :client
  
  validates :client_id, :data, :tipo, :qte, presence: true

  def credito_debito
  	case self.tipo
  		when -1 then "Saida"
  		when  1	then "Entrada"
  		else ""
  	end
  end

  def self.saldo(client=nil)
    #date.nil? ? CurrentAccount.sum('price*type_launche') : CurrentAccount.where(date_ocurrence: date).sum('price*type_launche')
    client.nil? ? ControlPallet.sum('qte*tipo') : ControlPallet.where(client_id: client).sum('qte*tipo')
  end  


end

class Pallet < ActiveRecord::Base
  belongs_to :client

  before_create :set_status

  def set_status
  	self.status = 0
  end

  def status_name
    case self.status
	    when 0 then "Aberto"
	    when 1 then "Agendado"
	    when 2 then "OS Criada"
    end
  end
end

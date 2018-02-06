class Task < ActiveRecord::Base
  validates :employee_id, presence: true
  validates :name, presence: true

  belongs_to :employee

  scope :the_day, -> {where('DATE(created_at) = ?', Date.current) }

  module TypeStatus
    NAO_INICIADO = 0
    CONCLUIDA_NO_PRAZO = 1
    CONCLUIDA_FORA_PRAZO = 2
    ATRASADA = 3
  end

  def status_name
  	case self.status
	  	when 0 then "Não Iniciado"
	  	when 1 then "Concluida no prazo"
	  	when 2 then "Concluida fora do prazo"
	  	when 3 then "Atrasado"
  	end
  end

  def allocated_and_observation
  	case self.allocated
  	 when 0 then texto = "Não, "
  	 when 1 then texto = "Sim, "
  	end
  	texto += self.allocated_observation
  end

  def self.ransackable_attributes(auth_object = nil)
    ['employee_id', 'name', 'body_cont', 'start_date', 'finish_date', 'status']
  end

end

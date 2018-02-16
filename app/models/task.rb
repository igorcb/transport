class Task < ActiveRecord::Base
  validates :employee_id, presence: true
  validates :name, presence: true
  validates :start_date, presence: true
  validates :finish_date, presence: true

  belongs_to :employee

  scope :the_day, -> {where('DATE(created_at) = ?', Date.current) }

  before_save { |t| t.status = TypeStatus::NAO_INICIADO }

  module TypeStatus
    NAO_INICIADO = 0
    INICIADO = 1
    CONCLUIDA_NO_PRAZO = 2
    CONCLUIDA_FORA_PRAZO = 3
    ATRASADA = 4
  end

  def status_name
  	case self.status
	  	when 0 then "Não Iniciado"
      when 1 then "Iniciado"
	  	when 2 then "Concluida no prazo"
	  	when 3 then "Concluida fora do prazo"
	  	when 4 then "Atrasado"
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

  def started?
    #start_date.blank? ? false : true
    self.status == Task::TypeStatus::NAO_INICIADO
  end

  def finished?
    self.status == Task::TypeStatus::INICIADO
  end

  def start
    # so pode informar recebimento se a remessa estiver no status FINISH_TYPING
    # fazer checagem se necessario
    return_value = false
    begin
      ActiveRecord::Base.transaction do
        return_value = true
        self.update_attributes(status: Task::TypeStatus::INICIADO)
      end
    rescue exception
      self.update_attributes(status: Task::TypeStatus::NAO_INICIADO)
      return_value = false
      raise ActiveRecord::Rollback
    end
  end

  def finish
    # so pode informar recebimento se a remessa estiver no status FINISH_TYPING
    # fazer checagem se necessario
    return_value = false
    begin
      ActiveRecord::Base.transaction do
        if finish_date > Date.current
          self.update_attributes(date_finalization: Time.current, status: Task::TypeStatus::CONCLUIDA_NO_PRAZO)
        else
          self.update_attributes(date_finalization: Time.current, status: Task::TypeStatus::CONCLUIDA_FORA_PRAZO)
        end
        return_value = true
      end
    rescue exception
      self.update_attributes(status: Task::TypeStatus::NAO_INICIADO)
      return_value = false
      raise ActiveRecord::Rollback
    end
  end

end

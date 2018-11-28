class PhoneCall < ActiveRecord::Base
  belongs_to :type_service, required: false

  validates :nome, presence: true, length: { maximum: 100 }
  validates :telefone, presence: true, length: { maximum: 50 }
  validates :email, length: { maximum: 100 }
  validates :type_service_id, presence: true, length: { maximum: 10 }
  validates :assunto, presence: true
  validates :status, presence: true

  module TipoStatus
  	ABERTO = 0
  	PENDENTE = 1
  	CONCLUIDO = 2
  end

  def status_descricao
  	case self.status
      when 0 then "Aberto"
      when 1 then "Pendente"
      when 2 then "Concluído"

  	end
  end

end

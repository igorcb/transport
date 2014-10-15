class Operating < ActiveRecord::Base
  belongs_to :driver
  belongs_to :client

  validates :driver_id, presence: true
  validates :client_id, presence: true
  validates :placa, presence: true
  validates :cte, presence: true
  validates :danfe, presence: true
  validates :chave_cte, presence: true
  validates :chave_nfe, presence: true

  def fpgto_nome
    case self.fpgto
      when 0 then "A Vista"
      when 1 then "A Prazo"
    end
  end  
end

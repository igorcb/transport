class PriceDriver < ActiveRecord::Base
  validates :uf_tipo,  presence: true
  validates :tipo, presence: true
  #validates :driver_id,  presence: true
  validates :valor, presence: true, uniqueness: {scope: [:driver_id, :uf_tipo, :tipo] }
  
  belongs_to :driver

  def uf_tipo_nome
    case self.uf_tipo
      when 0 then 'Dentro Do Estado'
      when 1 then 'Dentro Do Estado'
    end
  end

  def tipo_nome
    case self.tipo
      when 0 then 'p/ KM'
      when 1 then 'p/ Hora'
      when 2 then 'p/ Diaria'
    end
  end
  

end

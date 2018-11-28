class TablePrice < ActiveRecord::Base
  validates :uf_tipo, presence: true
  validates :tipo, presence: true
  validates :valor, presence: true

	belongs_to :driver, class_name: "Driver", foreign_key: "table_price_id", polymorphic: true, dependent: :destroy, required: false
	belongs_to :veichle, class_name: "Veichle", foreign_key: "table_price_id", polymorphic: true, dependent: :destroy, required: false
  belongs_to :employee, class_name: "Employee", foreign_key: "table_price_id", polymorphic: true, dependent: :destroy, required: false


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

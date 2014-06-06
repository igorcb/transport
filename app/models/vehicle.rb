class Vehicle < ActiveRecord::Base
  validates :tipo_veiculo, presence: true, :numericality => { :only_integer => true }, inclusion: { in: 0..4 }
  validates :marca, presence: true, length: { maximum: 20 } 
  validates :modelo, presence: true, length: { maximum: 20 } 
  validates :ano, presence: true, :numericality => { :only_integer => true }
  validates :cor, presence: true, length: { maximum: 20 } 
  validates :municipio_emplacamento, presence: true, length: { maximum: 100 }
  validates :estado, presence: true, length: { maximum: 2 }
  validates :renavan, presence: true, length: { maximum: 20 }
  validates :chassi, presence: true, length: { maximum: 20 }
  validates :capacidade, presence: true
  validates :placa, presence: true, length: { maximum: 7 }
  validates :especie, presence: true
  validates :numero_eixos, presence: true
  validates :numero_loks, presence: true
  #validates :grade, presence: true
  #validates :cordas, presence: true
  #validates :lonas, presence: true
  #validates :capacitacao, presence: true
  #validates :kit_quimico, presence: true


  has_many :table_prices, class_name: "TablePrice", foreign_key: "table_price_id", :as => :table_price, dependent: :destroy
  accepts_nested_attributes_for :table_prices, allow_destroy: true

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  has_many :drivings
  has_many :drivers, :through => :drivings
  accepts_nested_attributes_for :drivings, allow_destroy: true, reject_if: :all_blank

  has_many :ownerships
  has_many :owners, :through => :ownerships
  accepts_nested_attributes_for :ownerships, allow_destroy: true, reject_if: :all_blank

	module TipoVeiculo
		STANDARD = 0
		LS = 1
		BAU = 2
		TRUK = 3
		TROCO = 4
    CARRETA = 5
	end

  def cubagem
    largura * altura * comprimento
  end

  def tipo_veiculo_nome
    case self.tipo_veiculo
      when 0 then "STANDARD"
      when 1 then "LS"
      when 2 then "BAU"
      when 3 then "TRUK"
      when 4 then "TROCO"
      when 4 then "CARRETA"
    end
  end

end

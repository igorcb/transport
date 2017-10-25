class Vehicle < ActiveRecord::Base
  validates :tipo, presence: true, :numericality => { :only_integer => true }
  validates :tipo_veiculo, presence: true, :numericality => { :only_integer => true }
  validates :tipo_carroceria, presence: true, :numericality => { :only_integer => true }
  validates :marca, presence: true, length: { maximum: 20 } 
  validates :modelo, presence: true, length: { maximum: 20 } 
  validates :ano, presence: true, :numericality => { :only_integer => true }
  validates :cor, presence: true, length: { maximum: 20 } 
  validates :municipio_emplacamento, presence: true, length: { maximum: 100 }
  validates :estado, presence: true, length: { maximum: 2 }
  validates :renavan, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :chassi, presence: true, length: { maximum: 20 }
  #validates :capacidade, presence: true
  validates :capacity, presence: true
  validates :placa, presence: true, length: { maximum: 8 }, uniqueness: true
  validates :especie, presence: true
  validates :numero_eixos, presence: true
  validates :numero_loks, presence: true
  validates :qtde_paletes, presence: true
  validates :qtde_paletes, numericality: { greater_than: 0 }, :if => :tipo_reboque?


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

  scope :driver_all, -> (driver) { joins(:drivings).where("drivings.driver_id = ?", driver.id) }
  
  before_save {|v| v.placa = v.placa.upcase}

  module Tipo
    REBOQUE = 0
    TRACAO = 1
  end

  module TipoCarroceria
    # ABERTA = 0
    # FECHADA_BAU = 1
    # GRANELEIRA = 2
    # PORTA_CONTAINER = 3
    # SIDER = 4
    # NAO_APLICAVEL = 5
    BAU = 1
    GRANELEIRA = 2
    BUG_PORTA_CONTAINER = 3
    SIDER = 4
    BAU_FRIGORIFICO =5
    CACAMBA = 6
    GRADE_BAIXA = 7
    CAVAQUEIRA = 8
    PRANCHA = 9
    MUNK = 9
    SILO = 10
    TANQUE = 11
    GAIOLA = 12
    CEGONHEIRO = 13
    APENAS_CAVALO = 14
  end

	module TipoVeiculo
		#STANDARD = 0
		CARRETA_LS = 1
		VLC = 2
		TRUK = 3
		TOCO = 4
    CARRETA = 5
    TRES_QUARTOS = 6
    UTILITARIO = 7
    VAN = 8
    BITRUCK = 9
    RODOTREM = 10
    BITREM = 11
    NAOAPLICAVEL = 99
	end

  module TipoAssoalho
    FERRO = 0
    MADEIRA = 1
  end

  #validations
  def tipo_reboque?
    puts ">>>>>>>>>>>>>> tipo_reboque: #{self.tipo}"
    self.tipo == Tipo::REBOQUE
  end


  def cubagem
    largura * altura * comprimento
  end

  def tipo_nome
    case self.tipo
      when 0 then "REBOQUE"
      when 1 then "TRACAO"
    end
  end

  def tipo_piso_assoalho_nome
    case self.tipo_piso_assoalho
      when 0 then "FERRO"
      when 1 then "MADEIRA"
    end
  end


  def tipo_veiculo_nome
    case self.tipo_veiculo
      #when 0 then "STANDARD"
      when 1 then "CARRETA_LS"
      when 2 then "VLC"
      when 3 then "TRUK"
      when 4 then "TOCO"
      when 5 then "CARRETA"
      when 6 then "3/4"
      when 7 then "UTILITARIO"
      when 8 then "VAN"
      when 9 then "BITRUCK"
      when 10 then "RODOTREM"
      when 11 then "BITREM"
      else "NAO APLICAVEL"
    end
  end

  def tipo_carroceria_name
    case self.tipo_carroceria
      #when 0 then "ABERTA"
      #when 1 then "FECHADA BAU"
      when 1 then "BAÚ"
      when 2 then "GRANELEIRA"
      when 3 then "Bug Porta Container"
      when 4 then "SIDER"
      when 5 then "BAÚ FRIGORIFICO"
      when 6 then "CAÇAMBA"
      when 7 then "GRADE BAIXA"
      when 8 then "CAVAQUEIRA"
      when 9 then "PRANCHA"
      when 10 then "MUNK"
      when 11 then "SILO"
      when 12 then "TANQUE"
      when 13 then "GAIOLA"
      when 14 then "CEGONHEIRO"
      when 15 then "APENAS CAVALO"
     else "NAO APLICAVEL"
    end
  end

  def type_and_place
    "#{tipo_nome}/#{placa}"
  end


end

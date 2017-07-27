class DirectCharge < ActiveRecord::Base
  validates :carrier_id, :driver_id, presence: true
	validates :place, :date_charge, presence: true

  belongs_to :carrier
  belongs_to :driver
  belongs_to :user, class_name: "User", foreign_key: "user_id"

  #belongs_to :supplier, class_name: "Supplier", foreign_key: "supplier_id", polymorphic: true

  has_many :nfe_xmls, class_name: "NfeXml", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_xmls, allow_destroy: true, :reject_if => :all_blank
  
  has_many :ordem_services
  has_many :item_input_controls

  has_one :account_receivable

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  has_one :cancellation, class_name: "Cancellation", foreign_key: "cancellation_id"
  has_many :cancellations, class_name: "Cancellation", foreign_key: "cancellation_id", :as => :cancellation, dependent: :destroy
  accepts_nested_attributes_for :cancellations, allow_destroy: true, :reject_if => :all_blank

  has_many :comments, class_name: "Comment", foreign_key: "comment_id", :as => :comment, dependent: :destroy

  #before_save { |item| item.email = email.downcase }
  RECEBIMENTO_DESCARGA_HISTORIC = 100
  RECEBIMENTO_DESCARGA_PAYMENT_METHOD = 2
  RECEBIMENTO_DESCARGA_COST_CENTER = 81
  RECEBIMENTO_DESCARGA_SUB_COST_CENTER = 269
  RECEBIMENTO_DESCARGA_SUB_COST_CENTER_THREE = 160

  VALUE_DISCHARGE = 0.88 #POR TONELADA
  VALOR_DA_TONELADA = 25

  before_create do |cte|
   set_values
  end 

  before_save do |item| 
    item.place = place.upcase 
    item.place_cart = place_cart.upcase 
    item.place_cart_2 = place_cart_2.upcase 
  end
  
  after_save :processa_nfe_xmls

  module TipoCarga
    BATIDA = false
    PALETIZADA  = true
  end

  module TypeStatus
    OPEN   = 0
    RECEIVED = 1
    CLOSED  = 2
    BILLED = 3
    FINISH_TYPING = 4
  end #ordem do processo OPEN, FINISH TYPING, CLOSE, BILLIED

  def self.ransackable_attributes(auth_object = nil)
    ['id','carrier','driver','place','date_entry', 'date_receipt', 'status']
  end

  def palletized_status
    case self.palletized
      when false then "Nao"
      when true then "Sim"
      else "Nao Informado"
    end
  end

  def status_name
    case self.status
      when 0 then "Aberto"
      when 1 then "Recebido"
      when 2 then "Fechado"
      when 3 then "Faturado"
      when 4 then "Dig.Finalizada"
      else "Nao Informado"
    end
  end

  def set_values
    self.weight = 0.00
    self.volume = 0.00
    self.value_kg = valor_kg
    self.value_total = 0.00
    self.value_ton  = VALOR_DA_TONELADA
  end

  def set_peso_and_volume
    peso = self.nfe_xmls.sum(:peso)
    volume = self.nfe_xmls.sum(:volume)
    valor_total = peso * valor_kg
    ActiveRecord::Base.transaction do
      puts "peso: #{peso} and volume: #{volume}"
      InputControl.where(id: self.id).update_all(weight: peso, volume: volume, value_total: valor_total)
    end
  end

  def valor_tonelada
  	VALOR_DA_TONELADA
  end

  def valor_kg
    valor = 0.00
  	valor = (VALOR_DA_TONELADA / 1000.00)
  	valor
  end

  def valor_total
    valor = 0.00
    valor = valor_kg * self.peso
    valor
  end
  

end

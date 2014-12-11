class AccountPayable < ActiveRecord::Base
  
  validates :type_account, presence: true
  validates :supplier_id, presence: true
  validates :cost_center_id, presence: true
  validates :sub_cost_center_id, presence: true
  validates :historic_id, presence: true
  validates :documento, presence: true, length: { maximum: 10 }, numericality: { only_integer: true }
  validates :data_vencimento, presence: true
  validates :valor, presence: true, numericality: { greater_than: 0 }
  validates :observacao, presence: true

  belongs_to :supplier, class_name: "Supplier", foreign_key: "supplier_id", polymorphic: true, dependent: :destroy  
  belongs_to :cost_center
  belongs_to :sub_cost_center
  belongs_to :historic
  belongs_to :payment_method

  before_save :set_supplier_type

  def self.ransackable_attributes(auth_object = nil)
    ['data_vencimento', 'documento', 'supplier_id' ]
  end  

  def status_name
    case self.status
      when 0  then "Aberto"
      when 1  then "Pago Parcial"
      when 2  then "Pago"
    else "Nao Definido"
    end
  end 

  def type_account_name
    case self.type_account
      when 0  then "Fornecedor"
      when 1  then "Motorista"
      when 2  then "Cliente"
    end
  end

  protected
  
  def set_supplier_type
    case self.type_account
      when 0 then self.supplier_type = "Supplier"
      when 1 then self.supplier_type = "Driver"
      when 2 then self.supplier_type = "Client"
    end
  end


end

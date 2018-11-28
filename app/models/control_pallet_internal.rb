class ControlPalletInternal < ActiveRecord::Base
	validates :type_account, presence: true
	validates :responsable_id, presence: true
	validates :type_launche, presence: true
	validates :date_launche, presence: true
	validates :qtde, presence: true
	validates :equipament, presence: true

  belongs_to :boarding, required: false
  belongs_to :responsable, class_name: "Supplier", foreign_key: "responsable_id", polymorphic: true, required: false

  #default_scope { order(date_launche: :desc, id: :desc) }
  scope :credit, -> { where(type_launche: CreditDebit::CREDIT) }
  scope :debit,  -> { where(type_launche: CreditDebit::DEBIT)  }
  scope :all_equipament, -> { select(:equipament).uniq(:equipament).reorder(equipament: :asc) }
  scope :by_equipament, ->(equipament_id) { where(equipament: equipament_id)}
  scope :by_type_and_responsable, ->(type, responsable) { where(type_account: type, responsable_id: responsable)}

  scope :ordered, -> { order(date_launche: :desc, id: :desc) }

  default_scope { ordered }

  before_save :set_responsable_type

  module TypeEquipament
  	PALLET = 1
  	BIG_BAG = 2
  	CAIXA = 3
  	CHAPATEX = 4
  end

  module CreditDebit
    CREDIT = 1
    DEBIT   = -1
  end

  module TypeAccount
    SUPPLIER = 1
    DRIVER   = 2
    CLIENT   = 3
    EMPLOYEE = 4
    CARRIER  = 5
  end

  def type_account_name
    case self.type_account
      when 1  then "Fornecedor"
      when 2  then "Motorista"
      when 3  then "Cliente"
      when 4  then "Funcionario"
      when 5  then "Transportadora"
      else "*"
    end
  end

  def equipament_name
    case self.equipament
      when 1 then "Pallet"
      when 2 then "Big Bag"
      when 3 then "Caixa"
      when 4 then "ChapaTex"
      else "*"
    end
  end

  def credito_debito
  	case self.type_launche
  		when -1 then "Saida"
  		when  1	then "Entrada"
  		else ""
  	end
  end

  def self.get_equipament(type)
    case type.to_i
      when 1 then "Pallet"
      when 2 then "Big Bag"
      when 3 then "Caixa"
      when 4 then "ChapaTex"
      else "*"
    end
  end

  def self.equipament_and_credit_and_responsable(equipament, responsable_type, responsable)
    ControlPalletInternal.credit.by_equipament(equipament).by_type_and_responsable(responsable_type, responsable).sum("type_launche*qtde")
  end

  def self.equipament_and_debit_and_responsable(equipament, responsable_type, responsable)
    ControlPalletInternal.debit.by_equipament(equipament).by_type_and_responsable(responsable_type, responsable).sum("type_launche*qtde")
  end

  def self.equipament_saldo_and_responsable(equipament, responsable_type, responsable)
    ControlPalletInternal.by_equipament(equipament).by_type_and_responsable(responsable_type, responsable).sum("type_launche*qtde")
  end

  def self.equipament_saldo(equipament)
    ControlPalletInternal.by_equipament(equipament).sum("type_launche*qtde")
  end

  def print_term?
    self.boarding.present? && self.responsable_type == "Driver" ? true : false
  end

  def self.transfer(source, target)
    ActiveRecord::Base.transaction do
      @source = source
      @target = target
      @source.save!
      @target.save!
      return true
    end
    rescue Exception => e
      puts e.message
      @source.errors.add(:ControlPalletInternal, e.message)
      @target.errors.add(:ControlPalletInternal, e.message)
      return false
  end

  protected

	  def set_responsable_type
	    case self.type_account
	      when 1 then self.responsable_type = "Supplier"
	      when 2 then self.responsable_type = "Driver"
	      when 3 then self.responsable_type = "Client"
	      when 4 then self.responsable_type = "Employee"
	      when 5 then self.responsable_type = "Carrier"
	      else self.supplier_type = "Supplier"
	    end
	  end

end

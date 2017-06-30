class ControlPalletInternal < ActiveRecord::Base
	validates :type_account, presence: true
	validates :responsable_id, presence: true
	validates :type_launche, presence: true
	validates :date_launche, presence: true
	validates :qtde, presence: true
	validates :equipament, presence: true

  belongs_to :responsable, class_name: "Supplier", foreign_key: "responsable_id", polymorphic: true

  before_save :set_responsable_type

  module TypeEquipament
  	PALLET = 1
  	BIG_BAG = 2
  	CAIXA = 3
  	CHAPATEX = 4
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
      when 1  then "Pallet"
      when 2  then "Big Bag"
      when 3  then "Caixa"
      when 4  then "ChapaTex"
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

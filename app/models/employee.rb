class Employee < ActiveRecord::Base
  validates :tipo, presence: true, :numericality => { :only_integer => true }, inclusion: { in: 0..1 }
  validates :cpf, presence: true, uniqueness: true, length: { maximum: 14 }
  validates :nome, presence: true, length: { maximum: 100 } 
  validates :apelido, presence: true, length: { maximum: 100 } 
  validates :cep, presence: true, length: { maximum: 10 }
  validates :endereco, presence: true, length: { maximum: 100 }
  validates :numero, presence: true, length: { maximum: 15 } 
  validates :complemento, length: { maximum: 100 }
  validates :bairro, presence: true, length: { maximum: 100 }
  validates :cidade, presence: true, length: { maximum: 100 }
  validates :estado, presence: true, length: { maximum: 2 }

  has_many :contacts, class_name: "Contact", foreign_key: "contact_id", :as => :contact, dependent: :destroy
  accepts_nested_attributes_for :contacts, allow_destroy: true

  has_many :table_prices, class_name: "TablePrice", foreign_key: "table_price_id", :as => :table_price, dependent: :destroy
  accepts_nested_attributes_for :table_prices, allow_destroy: true

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  has_many :specialty_employees#, as: :specialty_employee, dependent: :destroy
  accepts_nested_attributes_for :specialty_employees, allow_destroy: true, reject_if: :all_blank
  

  module TipoEmployee
  	FIXO = 0
  	DIARISTA = 1
  end

  def tipo_funcionario
    case self.tipo
    when 0 then "Fixo"
    when 1 then "Diarista"
      
    end
    
  end

end

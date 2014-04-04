class Driver < ActiveRecord::Base
  validates :cpf, presence: true, uniqueness: true, length: { maximum: 14 }
  validates :nome, presence: true, length: { maximum: 100 } 
  validates :fantasia, presence: true, length: { maximum: 100 } 
  validates :cep, presence: true, length: { maximum: 10 }
  validates :endereco, presence: true, length: { maximum: 100 }
  validates :numero, presence: true, length: { maximum: 15 } 
  validates :complemento, length: { maximum: 100 }
  validates :bairro, presence: true, length: { maximum: 100 }
  validates :cidade, presence: true, length: { maximum: 100 }
  validates :estado, presence: true, length: { maximum: 2 }
  validates :rg, presence: true, length: { maximum: 20 }
  validates :cnh, presence: true, length: { maximum: 20 }
  validates :categoria, presence: true, :numericality => { :only_integer => true }, inclusion: { in: 0..8 }
  validates :validade_cnh, presence: true
  validates :data_emissao, presence: true

  has_many :contacts, class_name: "Contact", foreign_key: "contact_id", :as => :contact, dependent: :destroy
  accepts_nested_attributes_for :contacts, allow_destroy: true

  has_many :price_drivers
  accepts_nested_attributes_for :price_drivers, allow_destroy: true

  module Categoria
  	A = 0
  	B = 1
  	C = 2
  	D = 3
  	E = 4
  	AB = 5
  	AC = 6
  	AD = 7
  	AE = 8
  end

  def categoria_nome
    case self.categoria
      when 0 then "A"
      when 1 then "B"
      when 2 then "C"
      when 3 then "D"
      when 4 then "E"
      when 5 then "AB"
      when 6 then "AC"
      when 7 then "AD"
      when 8 then "AE"
    end
  end

end

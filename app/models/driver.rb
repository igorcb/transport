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
  validates :orgao_expeditor, presence: true, length: { maximum: 20 }
  validates :data_emissao_rg, presence: true
  validates :data_nascimento, presence: true
  validates :municipio_nascimento, presence: true, length: { maximum: 100 }
  validates :estado_nascimento, presence: true, length: { maximum: 2 }
  validates :inss, presence: true, length: { maximum: 20 }
  validates :cnh, presence: true, length: { maximum: 20 }
  validates :registro_cnh, presence: true,length: { maximum: 20 }
  validates :validade_cnh, presence: true
  validate  :expiration_validade_cnh
  validates :nome_do_pai, presence: true, length: { maximum: 100 }
  validates :nome_da_mae, presence: true, length: { maximum: 100 }

  validates :categoria, presence: true, :numericality => { :only_integer => true }, inclusion: { in: 0..8 }

  has_many :contacts, class_name: "Contact", foreign_key: "contact_id", :as => :contact, dependent: :destroy
  accepts_nested_attributes_for :contacts, allow_destroy: true

  has_many :account_banks, class_name: "AccountBank", foreign_key: "account_id", :as => :contact, dependent: :destroy
  accepts_nested_attributes_for :account_banks, allow_destroy: true

  has_many :table_prices, class_name: "TablePrice", foreign_key: "table_price_id", :as => :table_price, dependent: :destroy
  accepts_nested_attributes_for :table_prices, allow_destroy: true

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  has_many :driver_restrictions, class_name: "DriverRestriction", foreign_key: "driver_id", dependent: :destroy
  accepts_nested_attributes_for :driver_restrictions, allow_destroy: true

  has_attached_file :avatar, styles: lambda { |a| a.instance.avatar_content_type =~ %r(image) ? { mini: "144x>90"} : {} }
  #validates_attachment_presence :avatar

  has_many :drivings
  has_many :vehicles, :through => :drivings
  accepts_nested_attributes_for :drivings, allow_destroy: true, reject_if: :all_blank

  has_many :account_payables, class_name: "AccountPayable", foreign_key: "supplier_id"
  has_many :ordem_services
  has_many :ocurrences

  before_destroy :can_destroy?

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
  
  #methods for validations
  def expiration_validade_cnh
    if validade_cnh.present? && validade_cnh < Date.today
      errors.add(:validade_cnh, "can't be in the past")
    end
  end


  #methods do model
  def distric_city_state_cep
    "#{bairro} - #{cidade} - #{estado} - CEP: #{cep}"
  end

  def telefone_completo
    # seperar por virgula os contatos, somente o telefone
    fone = ''
    contato = self.contacts.first if self.contacts.exists?
    fone = contato.nome + ": " if self.contacts.exists?
    self.contacts.each do |contact|
      fone +=  " #{contact.fone}, "
    end

    #email = ""
    #self.emails.each do |email|
    #  email += "#{email.email}, "
    #end

    #fone = fone += email
    fone
  end

  private
    def can_destroy?
      if self.ordem_services.present? || self.account_payables.present?
        errors.add(:base, "You can not delete record with relationship") 
        return false
      end
    end
end

class Client < ActiveRecord::Base
  validates :tipo_pessoa, presence: true, :numericality => { :only_integer => true }, inclusion: { in: 0..1 }
  validates :cpf_cnpj, presence: true, uniqueness: true, length: { maximum: 18 }
  validates :group_client_id, presence: true
  validates :nome, presence: true, length: { maximum: 100 } 
  validates :fantasia, presence: true, length: { maximum: 100 } 
  validates :cep, presence: true, length: { maximum: 10 }
  validates :endereco, presence: true, length: { maximum: 100 }
  validates :numero, presence: true, length: { maximum: 15 } 
  validates :complemento, length: { maximum: 100 }
  validates :bairro, presence: true, length: { maximum: 100 }
  validates :cidade, presence: true, length: { maximum: 100 }
  validates :estado, presence: true, length: { maximum: 2 }
  
  validates :inscricao_estadual, length: { maximum: 20 }
  validates :inscricao_municipal, length: { maximum: 20 }

  validates :faturar_cada, presence: true, if: :faturar?
  validates :vencimento_para, presence: true, if: :faturar?
  validates :qtde_parcela, presence: true, numericality: { greater_than: 0 }, if: :faturar?

  validates :tipo_cliente, presence: true

  belongs_to :group_client
  
  belongs_to :user_created, class_name: "User", foreign_key: "user_created_id"
  belongs_to :user_updated, class_name: "User", foreign_key: "user_updated_id"

  has_many :ordem_services
  has_many :pallets
  has_many :account_payables, class_name: "AccountPayable", foreign_key: "supplier_id"

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  has_many :contacts, class_name: "Contact", foreign_key: "contact_id", :as => :contact, dependent: :destroy
  accepts_nested_attributes_for :contacts, allow_destroy: true

  has_many :emails, class_name: "Email", foreign_key: "email_id", :as => :email, dependent: :destroy
  accepts_nested_attributes_for :emails, allow_destroy: true

  has_many :account_banks, class_name: "AccountBank", foreign_key: "account_id", :as => :contact, dependent: :destroy
  accepts_nested_attributes_for :account_banks, allow_destroy: true

  # has_many :representatives, class_name: "Representative", foreign_key: "representative_id", :as => :email, dependent: :destroy
  # accepts_nested_attributes_for :emails, allow_destroy: true
  has_many :client_representatives
  #has_many :representatives, :through => :client_representatives
  accepts_nested_attributes_for :client_representatives, allow_destroy: true, reject_if: :all_blank

  has_many :representatives, :through => :client_representatives
  
  #has_and_belongs_to_many :representatives

  has_one :client_table_price

  has_many :client_table_prices, -> { where(client_table_price_type: "Client") }, class_name: 'ClientTablePrice', foreign_key: :client_table_price_id

  has_many :client_discharges
  has_many :client_requirements

  before_destroy :can_destroy?

  scope :billing, -> { where(faturar:true) }
  scope :client_table_price_reset, -> { joins(:client_table_price).where(client_table_prices: {reset: true}) }

  module TipoPessoa
  	FISICA = 0
  	JURIDICA = 1
  end
  
  module TipoCliente 
    NORMAL = 0
    ESPECIAL = 1
  end

  module TypeHeightMaximumPallet
    STANDARD_MANUFACTURER = 0
    STANDARD_CLIENT = 1
    STANDARD_CLIENT_AND_PRODUCT = 2
  end

  def tipo_cliente_nome
    case self.tipo_cliente
      when 0 then "Normal"
      when 1 then "Especial"
    end
  end

  def type_height_maximum_pallet_name
    case self.type_height_maximum_pallet
      when 0 then "Padrao do Fabricante"
      when 1 then "Padrao do Cliente"
      when 2 then "Padrao do Cliente e Produto"
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ['nome', 'cpf_cnpj', 'fantasia', 'estado', 'cidade']
  end

  def self.search_numero(numero)
    #desacentualize(pla_descricao)
    consultar_numero(numero)
  end

  def contatos
    fone = ''
    self.contacts.each do |contact|
      fone +=  "#{contact.nome}: #{contact.fone}, "
    end
    fone
  end

  def fone_all
    #self.contacts.map {|m| [m.nome, m.fone]}  
    self.contacts.map{|c| [c.nome + ':', c.fone + ', ']}.join()
    #self.contacts.select([:nome, :fone]). map {|c|  "#{c.nome}: #{c.fone}" }
  end

  def telefone_completo
    # seperar por virgula os contatos, somente o telefone
    #contato = self.contacts.first
    #fone = contato.nome + ": "
    fone = ''
    self.contacts.where(tipo: Contact::TipoContato::RESPONSAVEL_CARGA ).each do |contact|
      fone +=  "#{contact.nome}: #{contact.fone}, "
    end
    #email = self.emails.first
    #fone = fone += email.email

    email = ""
    self.emails.where(resposavel_carga: true) do |email|
      email += "#{email.email}, "
    end

    fone = fone += email
  end

  def telefone_completo_palete
    # seperar por virgula os contatos, somente o telefone
    #contato = self.contacts.first
    #fone = contato.nome + ": "
    fone = ''
    self.contacts.where(tipo: Contact::TipoContato::RESPONSAVEL_PALETE ).each do |contact|
      fone +=  "#{contact.nome}: #{contact.fone}, "
    end
    #email = self.emails.first
    #fone = fone += email.email

    email = ""
    self.emails.where(resposavel_carga: true) do |email|
      email += "#{email.email}, "
    end

    fone = fone += email
  end

  def fantasia_cidade
    "#{fantasia} - #{cidade} - #{estado}"
  end

  # def representative(billing_client)
  #   self.client_representatives.where(billing_client_id: billing_client).first
  # end

  def client_table_price_reset
    ClientTablePrice.where(client_id: self.id, reset: true).first
  end

  private 
    def can_destroy?
      if self.ordem_services.present? || 
         self.account_payables.present? ||
         self.pallets.present?

        puts ">>>>>>>>>>>>>>>>>>>>>>>>>. não pode apagar"
        errors.add(:base, "You can not delete record with relationship") 
        #self.errors[:base] << "You can not delete record with relationship"
        #errors.add_to_base "You can not delete record with relationship"
        return false
      end
    end

end

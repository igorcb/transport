class Carrier < ActiveRecord::Base
  validates :cnpj, presence: true, uniqueness: true, length: { maximum: 18 }
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

  has_many :contacts, class_name: "Contact", foreign_key: "contact_id", :as => :contact, dependent: :destroy
  accepts_nested_attributes_for :contacts, allow_destroy: true

  has_many :emails, class_name: "Email", foreign_key: "email_id", :as => :email, dependent: :destroy
  accepts_nested_attributes_for :emails, allow_destroy: true

  has_many :account_banks, class_name: "AccountBank", foreign_key: "account_id", :as => :contact, dependent: :destroy
  accepts_nested_attributes_for :account_banks, allow_destroy: true

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  has_many :account_payables, class_name: "AccountPayable", foreign_key: "supplier_id"

  has_many :ordem_services

  has_many :credentials, class_name: "CarrierCredential", foreign_key: "carrier_source_id"

  has_many :client_table_prices, -> { where(client_table_price_type: "Carrier") }, class_name: 'ClientTablePrice', foreign_key: :client_table_price_id

  before_destroy :can_destroy?

  def self.ransackable_attributes(auth_object = nil)
    ['id','nome', 'cnpj', 'fantasia', 'estado', 'cidade']
  end

  def name_state
    "#{nome} - #{estado}"
  end

  def distric_city_state_cep
    "#{bairro} - #{cidade} - #{estado} - CEP: #{cep}"
  end

  def self.carrier_default
    conf = ConfigSystem.where(config_key: 'CARRIER_DEFAULT').first
    conf.config_value.to_i
  end

  def cpf_cnpj
    self.cnpj
  end

  def accept_operational
    false
  end

  private
    def can_destroy?
      if self.ordem_services.present? || self.account_payables.present?
        errors.add(:base, "You can not delete record with relationship")
        return false
      end
    end

end

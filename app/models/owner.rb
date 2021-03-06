class Owner < ActiveRecord::Base
  validates :cpf_cnpj, presence: true, uniqueness: true, length: { maximum: 18 }
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
  validates :rg, length: { maximum: 20 }
  validates :orgao_emissor, length: { maximum: 20 }	

  has_many :contacts, class_name: "Contact", foreign_key: "contact_id", :as => :contact, dependent: :destroy
  accepts_nested_attributes_for :contacts, allow_destroy: true

  has_many :emails, class_name: "Email", foreign_key: "email_id", :as => :email, dependent: :destroy
  accepts_nested_attributes_for :emails, allow_destroy: true  

  has_many :ownerships
  has_many :vehicles, :through => :ownerships
  accepts_nested_attributes_for :ownerships, allow_destroy: true, reject_if: :all_blank  

  def distric_city_state_cep
    "#{bairro} - #{cidade} - #{estado} - CEP: #{cep}"
  end
  
end

class Client < ActiveRecord::Base
  validates :tipo_pessoa, presence: true, :numericality => { :only_integer => true }, inclusion: { in: 0..1 }
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

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  has_many :contacts, class_name: "Contact", foreign_key: "contact_id", :as => :contact, dependent: :destroy
  accepts_nested_attributes_for :contacts, allow_destroy: true

  has_many :emails, class_name: "Email", foreign_key: "email_id", :as => :email, dependent: :destroy
  accepts_nested_attributes_for :emails, allow_destroy: true

  module TipoPessoa
  	FISICA = 0
  	JURIDICA = 1
  end

  def telefone_completo
    # seperar por virgula os contatos, somente o telefone
    contato = self.contacts.first
    fone = contato.nome + ": "
    self.contacts.where(tipo: Contact::TipoContato::RESPONSAVEL_CARGA ).each do |contact|
      fone +=  "#{contact.fone}, "
    end
    #email = self.emails.first
    #fone = fone += email.email

    email = ""
    self.emails.where(resposavel_carga: true) do |email|
      email += "#{email.email}, "
    end

    fone = fone += email
  end
end

class OrdemServiceChange < ActiveRecord::Base
  belongs_to :ordem_service, required: false
  belongs_to :driver, required: false

  validates :source_cep, :source_numero, :source_endereco, :source_cidade, :source_estado, presence: true
  validates :target_cep, :target_numero, :target_endereco, :target_cidade, :target_estado, presence: true

  validates :cubagem, presence: true
#  validates :valor_declarado, presence: true
#  validates :valor_total, presence: true

  def stretch
    "#{self.source_cidade} X #{self.target_cidade}"
  end

  def status_compartilhado
  	self.compartilhado? ? "COMPARTILHADO" : "EXCLUSIVO"
  end

  def date_limit
    self.dias.business_days.after(self.ordem_service.data)
  end
end

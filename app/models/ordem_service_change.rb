class OrdemServiceChange < ActiveRecord::Base
  belongs_to :ordem_service
  belongs_to :driver

  validates :source_cep, :source_numero presence: true, :source_complemento, :source_endereco_completo,
   :source_endereco, :source_cidade, :source_estado
  validates :target_cep, :target_numero presence: true, :target_complemento, :target_endereco_completo,
   :target_endereco, :target_cidade, :target_estado

  validates :cubagem, presence: true
#  validates :valor_declarado, presence: true
#  validates :valor_total, presence: true  
end

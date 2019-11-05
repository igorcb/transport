class BreakdownNfeXml < ApplicationRecord
  belongs_to :nfe_xml
  belongs_to :input_control
  belongs_to :product

  #UN: Unidade, CX: Caixa, FRD: Fardo, PC: PEÇA, PCT: PACOTE

  enum type_breakdown: {primeira_perna_l7: 0, primeira_perna_transp: 1, segunda_perna_l7: 2}

end

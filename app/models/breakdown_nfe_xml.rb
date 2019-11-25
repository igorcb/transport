class BreakdownNfeXml < ApplicationRecord
  belongs_to :nfe_xml
  belongs_to :input_control
  belongs_to :product

  #UN: Unidade, CX: Caixa, FRD: Fardo, PC: PEÇA, PCT: PACOTE

  enum type_breakdown: {primeira_perna_l7: 0, primeira_perna_transp: 1, segunda_perna_l7: 2}

  def price_unit
    #ItemInputControl.where(input_control_id: input_control_id, nfe_xml_id: nfe_xml_id, product_id: product_id).first.valor_unitario
    ItemInputControl.where(input_control_id: input_control_id, nfe_xml_id: nfe_xml_id, product_id: product_id).first.valor_unitario_comer
  end

  def price_total
    value_faltas = (faltas || 0.00)
    value_avarias = (avarias || 0.00)
    total = (value_faltas + value_avarias) * price_unit
    #item.count
    #0.00
  end

  def self.total(input_control)
    total = 0.00
    BreakdownNfeXml.where(input_control_id: input_control.id).each do |item|
      value_faltas = (item.faltas || 0.00)
      value_avarias = (item.avarias || 0.00)
      #value = ItemInputControl.where(input_control_id: item.input_control_id, nfe_xml_id: item.nfe_xml_id, product_id: item.product_id).first.valor_unitario
      value = ItemInputControl.where(input_control_id: item.input_control_id, nfe_xml_id: item.nfe_xml_id, product_id: item.product_id).first.valor_unitario_comer
      value_total = (value_faltas + value_avarias) * value
      total += value_total
      value_faltas = 0.00
      value_avarias = 0.00
      value = 0.00
      value_total = 0.00
    end
    total
  end

end

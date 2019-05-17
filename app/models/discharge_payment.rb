class DischargePayment < ApplicationRecord
  belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "type_operation_id", polymorphic: true, required: false
  belongs_to :input_control, class_name: "InputControl", foreign_key: "type_operation_id", polymorphic: true, required: false
  #validates :client_source_id, uniqueness: { scope: [:client_id, :type_unit, :type_charge, :type_calc],
  #                                         message: ": tabela de descagar com tipo de unidade, tipo de carga, tipo de calculo já estão em uso. "}
  validates :type_operation_type, uniqueness: {scope: [:type_operation_id, :type_unit, :type_charge, :type_calc, :price]}
  enum type_unit: { box: "0", burden: "1", tambo: "2", big_bag: "3"}
  enum type_charge: { palletized: "0", slam: "1", mixed: "2", adjusted: "3"}
  enum type_calc: { weight: "0", unit: "1", value: "2"}
end

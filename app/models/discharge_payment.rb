class DischargePayment < ApplicationRecord
  #belongs_to :supplier, class_name: "Supplier", foreign_key: "supplier_id", polymorphic: true, required: false
  belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "type_operation_id", polymorphic: true, required: false
  belongs_to :input_control, class_name: "InputControl", foreign_key: "type_operation_id", polymorphic: true, required: false
end

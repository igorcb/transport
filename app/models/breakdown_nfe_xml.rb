class BreakdownNfeXml < ApplicationRecord
  belongs_to :nfe_xml
  belongs_to :input_control
  belongs_to :product
end

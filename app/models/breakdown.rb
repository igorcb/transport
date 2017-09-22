class Breakdown < ActiveRecord::Base
  belongs_to :boarding, class_name: "Boarding", foreign_key: "breakdown_id", polymorphic: true
  belongs_to :input_control, class_name: "InputControl", foreign_key: "breakdown_id", polymorphic: true
  belongs_to :nfe_xml
  belongs_to :product

  validates :type_breakdown, presence: true
  validates :nfe_xml_id, presence: true
  validates :product_id, presence: true

  module TypeBreakdown
  	PRIMEIRA_PERNA_L7 = 0
  	PRIMEIRA_PERNA_TRANSP = 1
  	SEGUNDA_PERNA_L7 = 2
  end

  def type_breakdown_name
  	case self.type_breakdown
	  	when 0 then "Primeira Perna - L7"
	  	when 1 then "Primeira Perna - Transp."
	  	when 2 then "Segunda Perna - L7"
  	end
  end

end

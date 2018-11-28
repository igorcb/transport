class Breakdown < ActiveRecord::Base
  #extend Enumerize
  #enumerize :role, in: [:user, :admin], default: :user
  #enumerize :unid_medida, in: [:un, :cx, :frd, :pc, :pct]

  #UN: Unidade, CX: Caixa, FRD: Fardo, PC: PEÇA, PCT: PACOTE

  belongs_to :boarding, class_name: "Boarding", foreign_key: "breakdown_id", polymorphic: true, required: false
  belongs_to :input_control, class_name: "InputControl", foreign_key: "breakdown_id", polymorphic: true, required: false
  belongs_to :nfe_xml, class_name: "NfeXml", foreign_key: "nfe_xml_id", required: false
  belongs_to :product, required: false

  #has_many :nfe_xmls, class_name: "NfeXml", foreign_key: "nfe_xml_id"
  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  validates :type_breakdown, presence: true
  validates :product_id, presence: true
  validates :unid_medida, presence: true

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

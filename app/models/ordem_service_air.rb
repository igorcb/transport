class OrdemServiceAir < ActiveRecord::Base

  validates :target_agent_id, presence: true
  validates :source_stretch_id, presence: true
  validates :target_stretch_id, presence: true
  validates :solicitante, presence: true

  belongs_to :ordem_service
  belongs_to :stretch_source, class_name: "Stretch", foreign_key: 'source_stretch_id'
  belongs_to :stretch_target, class_name: "Stretch", foreign_key: 'target_stretch_id'
  belongs_to :airline, class_name: "Carrier", foreign_key: 'airline_carrier_id'
  belongs_to :agent_target, class_name: "Carrier", foreign_key: 'target_agent_id'

  has_one :carrier
  has_one :agent_source, :through => :carrier

  def stretch
    "#{self.stretch_source.destino} X #{self.stretch_target.destino}" 
  end

end

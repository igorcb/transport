class Scheduling < ActiveRecord::Base

  validates :client, presence: true
  validates :type_modal, presence: true
  validates :date_scheduling, presence: true
  validates :time_scheduling, presence: true

  belongs_to :user

  has_many :nfe_xmls, class_name: "NfeXml", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_xmls, allow_destroy: true, :reject_if => :all_blank

  after_save :processa_nfe_xmls

  module TypeStatus
    NOT_RECEIVED = 0
    RECEIVED     = 1
    CANCEL       = 2
  end

  def status_name
  	case status
  		when 0 then "Não Recebido"
  		when 1 then "Recebido"
  		when 2 then "Cancelado"
  	end
  end

  def processa_nfe_xmls
    self.nfe_xmls.each do |nfe|
      NfeXml.processa_xml_input_control(nfe)
    end
  end

end

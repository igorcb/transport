class Scheduling < ActiveRecord::Base

  validates :client, presence: true, length: { maximum: 50 }
  validates :type_modal, presence: true
  validates :date_scheduling, presence: true
  validates :time_scheduling, presence: true

  belongs_to :user, required: false

  has_many :nfe_xmls, class_name: "NfeXml", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_xmls, allow_destroy: true, :reject_if => :all_blank

  after_save :processa_nfe_xmls

  default_scope { order(date_scheduling: :desc, time_scheduling: :desc, id: :desc) }
  #scope :the_day, -> { where(date_scheduling: Date.current).order(date_scheduling: :desc, time_scheduling: :desc, id: :desc) }
  scope :the_day, -> { where(date_scheduling: Date.current) }

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

  def input_control
    InputControl.where(container: self.container)
  end

  def self.ransackable_attributes(auth_object = nil)
    ['client', 'date_scheduling',  'status', 'date_scheduling', 'date_scheduling_client', 'container']
  end

  def processa_nfe_xmls
    self.nfe_xmls.each do |nfe|
      NfeXml.processa_xml_input_control(nfe)
    end
  end

  def get_number_nfe
    nfes = []
    self.nfe_xmls.each do |n|
      nfes << n.numero if n.numero.present?
    end
    nfes
  end

end

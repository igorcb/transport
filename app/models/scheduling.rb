class Scheduling < ActiveRecord::Base

  validates :client, presence: true
  validates :type_modal, presence: true
  validates :date_scheduling, presence: true
  validates :time_scheduling, presence: true

  has_many :nfe_xmls, class_name: "NfeXml", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_xmls, allow_destroy: true, :reject_if => :all_blank

  after_save :processa_nfe_xmls

  def processa_nfe_xmls
    self.nfe_xmls.each do |nfe|
      NfeXml.processa_xml_input_control(nfe)
    end
  end

end

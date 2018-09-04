class Notfis < ActiveRecord::Base
  belongs_to :client
  belongs_to :file_edi

  has_many :nfe_xmls, class_name: "NfeXml", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
end

class Notfis < ActiveRecord::Base
  belongs_to :client
  belongs_to :file_edi

  has_many :nfe_xmls, class_name: "NfeXml", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy

  def weight
  	nfe_xmls.sum(:peso)
  end

  def volume
  	nfe_xmls.sum(:volume)
  end

  def qtde_nfe
  	nfe_xmls.count
  end

  def get_nfes
    self.nfe_xmls.select(:numero).pluck(:numero).uniq
  end
end

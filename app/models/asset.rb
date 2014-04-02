class Asset < ActiveRecord::Base
	belongs_to :client	

  has_attached_file :asset, styles: { :thumb => "120x90>" }
  #validates_attachment :asset, :presence => true
  validates :asset_type, uniqueness: { scope: :asset_id }

end

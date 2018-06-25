class Meeting < ActiveRecord::Base
	has_many :subjects

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank	
end

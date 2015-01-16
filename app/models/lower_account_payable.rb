class LowerAccountPayable < ActiveRecord::Base
  belongs_to :account_payable
	belongs_to :cash_account
  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

end

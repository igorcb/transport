class AccountBank < ActiveRecord::Base
  

  belongs_to :driver, class_name: "Driver", foreign_key: "account_id", polymorphic: true, dependent: :destroy

end

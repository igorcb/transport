class AddStatusToPhoneCall < ActiveRecord::Migration
  def change
    add_column :phone_calls, :status, :integer
  end
end

class AddStatusToPhoneCall < ActiveRecord::Migration[5.0]
  def change
    add_column :phone_calls, :status, :integer
  end
end

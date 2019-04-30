class AddUserUpdatedToLowerAccountPayable < ActiveRecord::Migration[5.1]
  def change
    add_column :lower_account_payables, :user_created_id, :integer
    add_column :lower_account_payables, :user_updated_id, :integer
  end
end

class AddUserToAccountPayables < ActiveRecord::Migration[5.1]
  def change
    add_column :account_payables, :user_created_id, :integer, index: true
  end
end

class AddDefaultStatusToAccountPayables < ActiveRecord::Migration[5.0]
  def up
  	change_column :account_payables, :status, :integer, null: false, default: 0
  end

  def down
  	change_column :account_payables, :status, :integer
  end
end

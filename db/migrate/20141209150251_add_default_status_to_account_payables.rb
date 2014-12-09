class AddDefaultStatusToAccountPayables < ActiveRecord::Migration
  def up
  	change_column :account_payables, :status, :integer, null: false, default: 0
  end

  def down
  	change_column :account_payables, :status, :integer
  end
end

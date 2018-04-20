class AddCountEmailToAccountPayables < ActiveRecord::Migration
  def change
    add_column :account_payables, :count_email, :integer, default: 0
  end
end

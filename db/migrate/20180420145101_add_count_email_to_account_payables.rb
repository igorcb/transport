class AddCountEmailToAccountPayables < ActiveRecord::Migration[5.0]
  def change
    add_column :account_payables, :count_email, :integer, default: 0
  end
end

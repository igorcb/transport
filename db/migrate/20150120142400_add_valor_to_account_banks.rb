class AddValorToAccountBanks < ActiveRecord::Migration[5.0]
  def change
    add_column :account_banks, :valor, :decimal, :precision => 10, :scale => 2
  end
end

class AddNomeBancoToAccountBank < ActiveRecord::Migration
  def change
    add_column :account_banks, :nome_banco, :string, limit: 65
  end
end

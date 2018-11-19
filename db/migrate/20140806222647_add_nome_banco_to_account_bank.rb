class AddNomeBancoToAccountBank < ActiveRecord::Migration[5.0]
  def change
    add_column :account_banks, :nome_banco, :string, limit: 65
  end
end

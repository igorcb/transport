class AddHistoricoToCash < ActiveRecord::Migration[5.0]
  def change
    add_column :cashes, :historico, :string, limit: 250
  end
end

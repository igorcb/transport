class AddHistoricoToCash < ActiveRecord::Migration
  def change
    add_column :cashes, :historico, :string, limit: 250
  end
end

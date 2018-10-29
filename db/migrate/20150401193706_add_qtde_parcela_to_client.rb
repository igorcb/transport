class AddQtdeParcelaToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :qtde_parcela, :integer
  end
end

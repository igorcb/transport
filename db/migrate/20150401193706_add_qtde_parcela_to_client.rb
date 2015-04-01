class AddQtdeParcelaToClient < ActiveRecord::Migration
  def change
    add_column :clients, :qtde_parcela, :integer
  end
end

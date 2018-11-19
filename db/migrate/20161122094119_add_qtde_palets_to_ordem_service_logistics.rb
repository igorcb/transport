class AddQtdePaletsToOrdemServiceLogistics < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_service_logistics, :qtde_palets, :integer
  end
end

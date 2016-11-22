class AddQtdePaletsToOrdemServiceLogistics < ActiveRecord::Migration
  def change
    add_column :ordem_service_logistics, :qtde_palets, :integer
  end
end

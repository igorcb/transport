class AddQtdePaletsToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :qtde_paletes, :integer, null: false, default: 0
  end
end

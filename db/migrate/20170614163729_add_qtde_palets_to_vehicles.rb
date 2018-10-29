class AddQtdePaletsToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :qtde_paletes, :integer, null: false, default: 0
  end
end

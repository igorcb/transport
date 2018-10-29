class AddTipoPisoAssoalhoToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :tipo_piso_assoalho, :integer
  end
end

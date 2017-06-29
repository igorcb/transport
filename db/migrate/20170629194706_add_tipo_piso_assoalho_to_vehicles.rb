class AddTipoPisoAssoalhoToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :tipo_piso_assoalho, :integer
  end
end

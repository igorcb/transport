class AddQtdeVolumeAndPesoToOrdemServices < ActiveRecord::Migration
  def change
    add_column :ordem_services, :qtde_volume, :decimal, precision: 10, scale: 2
    add_column :ordem_services, :peso, :decimal, precision: 10, scale: 2
  end
end

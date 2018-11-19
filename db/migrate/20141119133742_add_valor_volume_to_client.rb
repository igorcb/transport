class AddValorVolumeToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :valor_volume, :decimal, precision: 10, scale: 2
    add_column :clients, :valor_peso, :decimal, precision: 10, scale: 2
  end
end

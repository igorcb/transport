class ModifyValorVolumeToClient < ActiveRecord::Migration[5.0]
  def up
  	change_column :clients, :valor_volume, :decimal, :precision => 10, :scale => 3
  	change_column :clients, :valor_peso, :decimal, :precision => 10, :scale => 3
  end

  def down
  	change_column :clients, :valor_volume, :decimal, :precision => 10, :scale => 2
  	change_column :clients, :valor_peso, :decimal, :precision => 10, :scale => 2
  end
end

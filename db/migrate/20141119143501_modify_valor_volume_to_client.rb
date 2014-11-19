class ModifyValorVolumeToClient < ActiveRecord::Migration
  def change
  	change_column :clients, :valor_volume, :decimal, :precision => 10, :scale => 3
  	change_column :clients, :valor_peso, :decimal, :precision => 10, :scale => 3
  end
end

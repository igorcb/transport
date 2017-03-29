class ChangePesoAndQtdeVolumeToOrdemServices < ActiveRecord::Migration
  def self.up
    change_table :ordem_services do |t|
      t.change :peso, :decimal, precision: 10, scale: 3, null: true
      t.change :qtde_volume, :decimal, precision: 10, scale: 3, null: true
    end
  end
  def self.down
    change_table :ordem_services do |t|
      t.change :peso, :decimal, precision: 10, scale: 2, null: false
      t.change :qtde_volume, :decimal, precision: 10, scale: 2, null: false
    end
  end
end

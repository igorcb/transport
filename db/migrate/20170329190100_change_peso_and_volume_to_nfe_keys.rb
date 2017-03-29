class ChangePesoAndVolumeToNfeKeys < ActiveRecord::Migration
  def self.up
    change_table :nfe_keys do |t|
      t.change :peso, :decimal, precision: 10, scale: 3, null: true
      t.change :volume, :decimal, precision: 10, scale: 3, null: true
    end
  end
  def self.down
    change_table :nfe_keys do |t|
      t.change :peso, :decimal, precision: 10, scale: 2, null: false
      t.change :volume, :decimal, precision: 10, scale: 2, null: false
    end
  end
end

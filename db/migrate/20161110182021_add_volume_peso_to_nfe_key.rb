class AddVolumePesoToNfeKey < ActiveRecord::Migration
  def change
    add_column :nfe_keys, :volume, :decimal, precision: 10, scale: 2
    add_column :nfe_keys, :peso, :decimal, precision: 10, scale: 2
  end
end

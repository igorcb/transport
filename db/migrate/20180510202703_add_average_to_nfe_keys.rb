class AddAverageToNfeKeys < ActiveRecord::Migration
  def change
    add_column :nfe_keys, :average, :decimal, precision: 20, scale: 4, default: 0
  end
end

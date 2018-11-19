class AddAverageToNfeKeys < ActiveRecord::Migration[5.0]
  def change
    add_column :nfe_keys, :average, :decimal, precision: 20, scale: 4, default: 0
  end
end

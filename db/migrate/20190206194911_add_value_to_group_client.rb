class AddValueToGroupClient < ActiveRecord::Migration[5.1]
  def change
    add_column :group_clients, :value_weight, :decimal
    add_column :group_clients, :value_ton, :decimal
  end
end

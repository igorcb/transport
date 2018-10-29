class AddNumeroToInventory < ActiveRecord::Migration[5.0]
  def change
    add_column :inventories, :numero, :integer, null: false
  end
end

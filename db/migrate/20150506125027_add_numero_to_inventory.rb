class AddNumeroToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :numero, :integer, null: false
  end
end

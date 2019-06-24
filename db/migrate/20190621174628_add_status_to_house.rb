class AddStatusToHouse < ActiveRecord::Migration[5.1]
  def change
    add_column :houses, :occupied, :boolean
    add_column :houses, :actived, :boolean
  end
end

class AddObsToAllTables < ActiveRecord::Migration
  def self.up
    add_column :clients, :obs, :text
    add_column :suppliers, :obs, :text
    add_column :drivers, :obs, :text
    add_column :vehicles, :obs, :text
    add_column :employees, :obs, :text
    add_column :carriers, :obs, :text
    add_column :owners, :obs, :text
  end

  def self.down
  	remove_column :clients, :obs
    remove_column :suppliers, :obs
    remove_column :drivers, :obs
    remove_column :vehicles, :obs
    remove_column :employees, :obs
    remove_column :carriers, :obs
    remove_column :owners, :obs
  end  
end



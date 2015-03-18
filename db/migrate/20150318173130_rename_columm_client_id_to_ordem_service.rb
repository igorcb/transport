class RenameColummClientIdToOrdemService < ActiveRecord::Migration
  def self.up
    rename_column :ordem_services, :client_id, :target_client_id
    add_column :ordem_services, :source_client_id, :integer
  end

  def self.down
    rename_column :ordem_services, :target_client_id, :client_id
    remove_column :ordem_services, :source_client_id
  end
end

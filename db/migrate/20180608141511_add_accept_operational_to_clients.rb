class AddAcceptOperationalToClients < ActiveRecord::Migration
  def change
    add_column :clients, :accept_operational, :boolean
  end
end

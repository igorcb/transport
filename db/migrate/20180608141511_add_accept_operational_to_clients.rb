class AddAcceptOperationalToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :accept_operational, :boolean
  end
end

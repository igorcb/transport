class AddGroupClientToClient < ActiveRecord::Migration
  def change
    add_column :clients, :group_client_id, :integer
  end
end

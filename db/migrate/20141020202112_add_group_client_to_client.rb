class AddGroupClientToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :group_client_id, :integer
  end
end

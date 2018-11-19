class AddClientToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :client, index: true
  end
end

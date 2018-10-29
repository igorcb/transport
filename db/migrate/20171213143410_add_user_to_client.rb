class AddUserToClient < ActiveRecord::Migration[5.0]
  def change
    add_reference :clients, :user_created, index: true
    add_reference :clients, :user_updated, index: true
  end
end

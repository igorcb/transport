class AddUserToClient < ActiveRecord::Migration
  def change
    add_reference :clients, :user_created, index: true
    add_reference :clients, :user_updated, index: true
  end
end

class AddUserToDriver < ActiveRecord::Migration[5.0]
  def change
    add_reference :drivers, :user_created, index: true
    add_reference :drivers, :user_updated, index: true
  end
end

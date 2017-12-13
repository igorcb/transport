class AddUserToDriver < ActiveRecord::Migration
  def change
    add_reference :drivers, :user_created, index: true
    add_reference :drivers, :user_updated, index: true
  end
end

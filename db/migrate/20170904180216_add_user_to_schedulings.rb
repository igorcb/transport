class AddUserToSchedulings < ActiveRecord::Migration
  def change
    add_reference :schedulings, :user, index: true
  end
end

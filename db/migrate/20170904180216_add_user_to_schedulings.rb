class AddUserToSchedulings < ActiveRecord::Migration[5.0]
  def change
    add_reference :schedulings, :user, index: true
  end
end

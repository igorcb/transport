class AddUserCreatedToPalletizing < ActiveRecord::Migration[5.1]
  def change
    add_reference :palletizings, :user_created, foreign_key:  {to_table: :users }
  end
end

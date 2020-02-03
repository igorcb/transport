class AddUserFinishToPalletizing < ActiveRecord::Migration[5.1]
  def change
    add_reference :palletizings, :user_finished, foreign_key:  {to_table: :users }
  end
end

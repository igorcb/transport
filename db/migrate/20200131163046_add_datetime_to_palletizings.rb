class AddDatetimeToPalletizings < ActiveRecord::Migration[5.1]
  def change
    add_column :palletizings, :start, :datetime
    add_column :palletizings, :finish, :datetime
  end
end

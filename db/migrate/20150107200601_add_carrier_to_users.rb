class AddCarrierToUsers < ActiveRecord::Migration
  def change
    add_column :users, :carrier_id, :integer
  end
end

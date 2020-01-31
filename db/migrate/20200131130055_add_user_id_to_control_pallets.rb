class AddUserIdToControlPallets < ActiveRecord::Migration[5.1]
  def change
    add_reference :control_pallets, :user, foreign_key: true
  end
end

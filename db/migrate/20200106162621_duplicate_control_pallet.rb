class DuplicateControlPallet < ActiveRecord::Migration[5.1]
  def up
    execute "SELECT * INTO control_pallet_copy FROM control_pallets"
  end

  def down
    execute "DROP TABLE control_pallet_copy"
  end
end

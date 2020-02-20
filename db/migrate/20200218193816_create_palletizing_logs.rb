class CreatePalletizingLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :palletizing_logs do |t|
      t.string :pallet_number
      t.integer :type_log
      t.string :historic
    end
  end
end

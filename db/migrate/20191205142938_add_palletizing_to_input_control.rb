class AddPalletizingToInputControl < ActiveRecord::Migration[5.1]
  def change
    add_column :input_controls, :palletizing, :integer
  end
end

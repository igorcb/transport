class CreatePalletizings < ActiveRecord::Migration[5.1]
  def change
    create_table :palletizings do |t|
      t.integer :view_mode
      t.references :input_control, foreign_key: true

      t.timestamps
    end
  end
end

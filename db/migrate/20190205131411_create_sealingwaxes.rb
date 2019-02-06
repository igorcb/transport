class CreateSealingwaxes < ActiveRecord::Migration[5.1]
  def change
    create_table :sealingwaxes do |t|
      t.integer :sealing_id
      t.string :sealing_type
      t.string :number

      t.timestamps
    end
  end
end

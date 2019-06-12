class CreateDeposits < ActiveRecord::Migration[5.1]
  def change
    create_table :deposits do |t|
      t.references :warehouse, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end

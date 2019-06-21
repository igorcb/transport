class CreateHouses < ActiveRecord::Migration[5.1]
  def change
    create_table :houses do |t|
      t.string :name
      t.references :floor, foreign_key: true

      t.timestamps
    end
  end
end

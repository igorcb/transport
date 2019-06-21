class CreateStreets < ActiveRecord::Migration[5.1]
  def change
    create_table :streets do |t|
      t.string :name
      t.references :deposit, foreign_key: true

      t.timestamps
    end
  end
end

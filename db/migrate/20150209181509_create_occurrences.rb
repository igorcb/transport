class CreateOccurrences < ActiveRecord::Migration
  def change
    create_table :occurrences do |t|
      t.references :driver, index: true
      t.string :placa
      t.string :cte
      t.date :data

      t.timestamps
    end
  end
end

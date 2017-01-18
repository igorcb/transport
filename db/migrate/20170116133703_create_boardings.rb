class CreateBoardings < ActiveRecord::Migration
  def change
    create_table :boardings do |t|
      t.references :carrier, index: true
      t.references :driver, index: true
      t.date :date_boarding

      t.timestamps
    end
  end
end

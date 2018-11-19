class CreateNotfis < ActiveRecord::Migration[5.0]
  def change
    create_table :notfis do |t|
      t.string :place
      t.references :client, index: true
      t.date :date_notfis

      t.timestamps
    end
  end
end

class CreateNotfis < ActiveRecord::Migration
  def change
    create_table :notfis do |t|
      t.string :place
      t.references :client, index: true
      t.date :date_notfis

      t.timestamps
    end
  end
end

class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :descricao, limit: 100, null: false

      t.timestamps
    end
    add_index :activities, :descricao, unique: true
  end
end

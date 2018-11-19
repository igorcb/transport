class CreateTypeServices < ActiveRecord::Migration[5.0]
  def change
    create_table :type_services do |t|
      t.string :descricao, limit: 100, null: false

      t.timestamps
    end
    add_index :type_services, :descricao, unique: true
  end
end

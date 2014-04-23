class CreateSpecialties < ActiveRecord::Migration
  def change
    create_table :specialties do |t|
      t.string :descricao, limit: 50, null: false
      t.decimal :valor, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end

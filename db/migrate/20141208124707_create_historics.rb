class CreateHistorics < ActiveRecord::Migration[5.0]
  def change
    create_table :historics do |t|
      t.string :descricao
      t.integer :tipo

      t.timestamps
    end
  end
end

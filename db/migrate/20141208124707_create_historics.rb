class CreateHistorics < ActiveRecord::Migration
  def change
    create_table :historics do |t|
      t.string :descricao
      t.integer :tipo

      t.timestamps
    end
  end
end

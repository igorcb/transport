class CreateStretches < ActiveRecord::Migration[5.0]
  def change
    create_table :stretches do |t|
      t.string :cidade, limit: 20
      t.string :estado, limit: 2
      t.string :destino, limit: 3

      t.timestamps
    end
  end
end

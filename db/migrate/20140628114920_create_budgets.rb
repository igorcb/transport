class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.date :data
      t.string :email
      t.string :nome
      t.string :fone
      t.string :estado_origem
      t.string :municipio_origem
      t.string :estado_destino
      t.string :municipio_destino

      t.timestamps
    end
  end
end

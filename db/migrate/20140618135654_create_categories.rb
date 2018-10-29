class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :descricao, limit: 100, null: false

      t.timestamps
    end
  end
end

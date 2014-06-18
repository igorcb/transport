class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :descricao, limit: 100, null: false

      t.timestamps
    end
  end
end

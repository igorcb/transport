class CreateBudgetItems < ActiveRecord::Migration[5.0]
  def change
    create_table :budget_items do |t|
      t.references :budget, index: true
      t.references :product, index: true
      t.integer :qtde

      t.timestamps
    end
  end
end

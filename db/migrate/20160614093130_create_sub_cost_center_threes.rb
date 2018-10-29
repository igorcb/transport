class CreateSubCostCenterThrees < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_cost_center_threes do |t|
      t.references :cost_center, index: true
      t.references :sub_cost_center, index: true
      t.string :descricao

      t.timestamps
    end
  end
end

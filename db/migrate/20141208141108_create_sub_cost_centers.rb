class CreateSubCostCenters < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_cost_centers do |t|
      t.references :cost_center, index: true
      t.string :descricao

      t.timestamps
    end
  end
end

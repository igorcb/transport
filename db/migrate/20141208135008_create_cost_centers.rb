class CreateCostCenters < ActiveRecord::Migration[5.0]
  def change
    create_table :cost_centers do |t|
      t.string :descricao

      t.timestamps
    end
  end
end

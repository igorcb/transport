class AddUnidMedidaToBreakdowns < ActiveRecord::Migration[5.0]
  def change
    add_column :breakdowns, :unid_medida, :string
  end
end

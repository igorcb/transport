class AddUnidMedidaToBreakdowns < ActiveRecord::Migration
  def change
    add_column :breakdowns, :unid_medida, :string
  end
end

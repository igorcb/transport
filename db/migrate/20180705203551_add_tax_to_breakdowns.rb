class AddTaxToBreakdowns < ActiveRecord::Migration
  def change
    add_column :breakdowns, :price, :decimal, precision: 20, scale: 2
    add_column :breakdowns, :ipi_tax, :decimal, precision: 20, scale: 2
    add_column :breakdowns, :ipi_value, :decimal, precision: 20, scale: 2
    add_column :breakdowns, :icms_tax, :decimal, precision: 20, scale: 2
    add_column :breakdowns, :icms_value, :decimal, precision: 20, scale: 2
    add_column :breakdowns, :base_calc, :decimal, precision: 20, scale: 2
    add_column :breakdowns, :price_total, :decimal, precision: 20, scale: 2
  end
end

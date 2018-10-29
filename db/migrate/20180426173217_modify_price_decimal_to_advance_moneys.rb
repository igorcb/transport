class ModifyPriceDecimalToAdvanceMoneys < ActiveRecord::Migration[5.0]
  def change
 		change_column :advance_moneys, :price, :decimal, precision: 10, scale: 2
  end
end
class ModifyPriceDecimalToAdvanceMoneys < ActiveRecord::Migration
  def change
 		change_column :advance_moneys, :price, :decimal, precision: 10, scale: 2
  end
end
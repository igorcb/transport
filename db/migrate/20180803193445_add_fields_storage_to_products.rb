class AddFieldsStorageToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :width,   :decimal, precision: 10, scale: 2
    add_column :products, :length,  :decimal, precision: 10, scale: 2
    add_column :products, :height,  :decimal, precision: 10, scale: 2
    add_column :products, :volume,  :decimal, precision: 10, scale: 2
    add_column :products, :weight_liquid,   :decimal, precision: 10, scale: 2
    add_column :products, :weight_gross, :decimal, precision: 10, scale: 2
    add_column :products, :ballast, :decimal, precision: 10, scale: 2
    add_column :products, :factor,  :integer, precision: 10, scale: 2
  end
end

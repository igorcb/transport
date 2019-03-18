class ChangeWidthAndLengthHeightToProducts < ActiveRecord::Migration[5.1]
  def self.up
    change_table :products do |t|
      t.change :width, :decimal, precision: 10, scale: 3, null: true
      t.change :length, :decimal, precision: 10, scale: 3, null: true
      t.change :height, :decimal, precision: 10, scale: 3, null: true
    end
  end
  def self.down
    change_table :products do |t|
      t.change :width, :decimal, precision: 10, scale: 2, null: true
      t.change :length, :decimal, precision: 10, scale: 2, null: true
      t.change :height, :decimal, precision: 10, scale: 2, null: true
    end
  end
end

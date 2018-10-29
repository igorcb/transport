class CashesValorChangeColumnType < ActiveRecord::Migration[5.0]
 def self.up
    change_table :cashes do |t|
      t.change :valor, :decimal, precision: 10, scale: 2, null: false
    end
  end
  def self.down
    change_table :cashes do |t|
      t.change :valor, :decimal
    end
  end
end

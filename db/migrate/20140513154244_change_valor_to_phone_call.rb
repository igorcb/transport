class ChangeValorToPhoneCall < ActiveRecord::Migration
  def self.up
    change_table :phone_calls do |t|
      t.change :valor, :decimal, precision: 10, scale: 2, null: true
    end
  end
  def self.down
    change_table :phone_calls do |t|
      t.change :valor, :decimal, precision: 10, scale: 2, null: false
    end
  end
end

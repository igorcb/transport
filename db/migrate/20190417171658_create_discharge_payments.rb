class CreateDischargePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :discharge_payments do |t|
      #t.polymorphic :discharge_payment, polymorphic: true, index: true
      t.references :type_operation, polymorphic: true, index: true, index: {:name => "idx_discharge_payments_polymorphic"}
      t.string :type_unit
      t.string :type_charge
      t.string :type_calc
      t.decimal :price, :precision => 10, :scale => 2

      t.timestamps
    end
  end
end

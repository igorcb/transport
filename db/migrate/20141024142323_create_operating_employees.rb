class CreateOperatingEmployees < ActiveRecord::Migration
  def change
    create_table :operating_employees do |t|
      t.references :operating, index: true
      t.references :employee, index: true
      t.decimal :valor_diaria, precision: 10, scale: 2, null: false
      t.decimal :valor_almoco, precision: 10, scale: 2, null: false
      t.decimal :valor_transporte, precision: 10, scale: 2, null: false
      t.decimal :valor_extra, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end


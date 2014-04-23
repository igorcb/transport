class CreateSpecialtyEmployees < ActiveRecord::Migration
  def change
    create_table :specialty_employees do |t|
      t.references :specialty, index: true
      t.references :employee, index: true
      t.decimal :valor

      t.timestamps
    end
  end
end

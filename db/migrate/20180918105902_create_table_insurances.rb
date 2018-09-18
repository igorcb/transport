class CreateTableInsurances < ActiveRecord::Migration
  def change
    create_table :table_insurances do |t|
      t.references :insurer, index: true
      t.string :state_source
      t.string :state_target
      t.decimal :percent

      t.timestamps
    end
  end
end

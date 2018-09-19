class CreatePolicieInsurances < ActiveRecord::Migration
  def change
    create_table :policie_insurances do |t|
      t.references :insurer, index: true
      t.references :broker, index: true
      t.integer :type_policie
      t.string :proposal
      t.string :policy
      t.date :date_start
      t.date :date_expired
      t.decimal :value, precision: 10, scale: 2

      t.timestamps
    end
  end
end

class CreateStretchRoutes < ActiveRecord::Migration[5.0]
  def change
    create_table :stretch_routes do |t|
      t.integer :stretch_source_id, null: false 
      t.integer :stretch_target_id, null: false
      t.decimal :tax_rate, :decimal, precision: 10, scale: 2, default: 0
      t.decimal :non_tax_rate, :decimal, precision: 10, scale: 2, default: 0
      t.decimal :secure_rate, :decimal, precision: 10, scale: 2, default: 0
      t.decimal :secure_rate_filch, :decimal, precision: 10, scale: 2, default: 0
      t.decimal :secure_rate_aggravated, :decimal, precision: 10, scale: 2, default: 0
      t.decimal :cost_kg, :decimal, precision: 10, scale: 2, default: 0
      t.decimal :tax_iss, :decimal, precision: 10, scale: 2, default: 0
      t.integer :travel_time
      t.integer :distance

      t.timestamps
    end
  end
end

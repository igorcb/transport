class CreateBreakdowns < ActiveRecord::Migration[5.0]
  def change
    create_table :breakdowns do |t|
      t.references :nfe_xml, index: true
      t.references :product, index: true
      t.integer :type_breakdown
      t.integer :sobras, default: 0
      t.integer :faltas, default: 0
      t.integer :avarias, default: 0

      t.timestamps
    end
  end
end

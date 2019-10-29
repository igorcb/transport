class CreateBreakdownNfeXmls < ActiveRecord::Migration[5.1]
  def change
    create_table :breakdown_nfe_xmls do |t|
      t.references :nfe_xml, foreign_key: true
      t.references :input_control, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :qtde

      t.timestamps
    end
  end
end

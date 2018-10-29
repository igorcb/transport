class CreateTableIcms < ActiveRecord::Migration[5.0]
  def change
    create_table :table_icms do |t|
      t.string :state_source
      t.string :state_target
      t.decimal :aliquot

      t.timestamps
    end
  end
end

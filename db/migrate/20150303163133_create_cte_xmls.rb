class CreateCteXmls < ActiveRecord::Migration[5.0]
  def change
    create_table :cte_xmls do |t|
      t.integer :status
      t.integer :error

      t.timestamps
    end
  end
end

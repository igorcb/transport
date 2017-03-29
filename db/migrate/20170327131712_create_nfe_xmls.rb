class CreateNfeXmls < ActiveRecord::Migration
  def change
    create_table :nfe_xmls do |t|
      t.integer :status
      t.integer :error
    end
  end
end

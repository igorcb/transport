class CreateInsurers < ActiveRecord::Migration
  def change
    create_table :insurers do |t|
      t.string :cnpj
      t.string :name

      t.timestamps
    end
  end
end

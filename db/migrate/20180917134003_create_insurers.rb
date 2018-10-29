class CreateInsurers < ActiveRecord::Migration[5.0]
  def change
    create_table :insurers do |t|
      t.string :cnpj
      t.string :name

      t.timestamps
    end
  end
end

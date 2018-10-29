class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.string :code
      t.string :name
      t.string :uf, limit: 2

      t.timestamps
    end
  end
end

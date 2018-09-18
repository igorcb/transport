class CreateBrokers < ActiveRecord::Migration
  def change
    create_table :brokers do |t|
      t.string :cnpj
      t.string :name

      t.timestamps
    end
  end
end

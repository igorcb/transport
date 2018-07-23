class CreateAntts < ActiveRecord::Migration
  def change
    create_table :antts do |t|
      t.string :rntrc
      t.string :cpf_cnpj
      t.string :name
      t.date :date_expiration

      t.timestamps
    end
  end
end

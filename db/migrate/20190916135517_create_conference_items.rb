class CreateConferenceItems < ActiveRecord::Migration[5.1]
  def change
    create_table :conference_items do |t|
      t.references :conference, foreign_key: true
      t.references :product
      t.integer :qtde_oper
      t.integer :qtde_sup
      t.integer :avaria
      t.integer :falta
      t.integer :sobra

      t.timestamps
    end
  end
end

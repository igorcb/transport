class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.string :banco, limit: 5, null: false
      t.string :nome, limit: 60, null: false

      t.timestamps
    end
  end
end

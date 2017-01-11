class CreateNfsKeys < ActiveRecord::Migration
  def change
    create_table :nfs_keys do |t|
      t.string :nfs, limit: 20, null: false, index: true
      t.string :chave, limit: 45, index: true
      t.integer :nfs_id
      t.string :nfs_type

      t.timestamps
    end
  end
end

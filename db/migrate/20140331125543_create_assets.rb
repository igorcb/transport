class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.integer :asset_id
      t.string :asset_type
      t.string :asset_file_name
      t.string :asset_content_type
      t.string :asset_file_size

      t.timestamps
    end
  end
end

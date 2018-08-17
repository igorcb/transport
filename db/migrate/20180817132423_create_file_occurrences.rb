class CreateFileOccurrences < ActiveRecord::Migration
  def change
    create_table :file_occurrences do |t|
      t.references :client, index: true
      t.date :date_file
      t.string :name_file
      t.text :content

      t.timestamps
    end
  end
end

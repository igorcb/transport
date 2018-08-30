class CreateFileEdis < ActiveRecord::Migration
  def change
    create_table :file_edis do |t|
      t.string :type_file
      t.date :date_file
      t.string :name_file
      t.text :content

      t.timestamps
    end
  end
end

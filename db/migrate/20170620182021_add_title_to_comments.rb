class AddTitleToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :title, :integer
    add_column :comments, :observation, :text
  end
end

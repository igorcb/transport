class AddTitleToComments < ActiveRecord::Migration
  def change
    add_column :comments, :title, :integer
    add_column :comments, :observation, :text
  end
end

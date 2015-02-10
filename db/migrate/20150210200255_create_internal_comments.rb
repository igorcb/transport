class CreateInternalComments < ActiveRecord::Migration
  def change
    create_table :internal_comments do |t|
    	t.string :email
      t.text :content
      t.string :comment_type
      t.integer :comment_id

      t.timestamps
    end
  end
end

class AddIndexToInternalComment < ActiveRecord::Migration
  def up
    add_index :internal_comments, [:comment_id, :comment_type], :name => "idx_internal_comments_on_os_id_and_os_type"
  end
  
  def down
    remove_index :internal_comments, name: :idx_internal_comments_on_os_id_and_os_type
  end
end

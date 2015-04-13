class AddAttachmentAssetToCteKeys < ActiveRecord::Migration
  def self.up
    change_table :cte_keys do |t|
      t.attachment :asset
    end
  end

  def self.down
    drop_attached_file :cte_keys, :asset
  end
end

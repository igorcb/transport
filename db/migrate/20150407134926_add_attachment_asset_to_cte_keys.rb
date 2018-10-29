class AddAttachmentAssetToCteKeys < ActiveRecord::Migration[5.0]
  def self.up
    change_table :cte_keys do |t|
      t.attachment :asset
    end
  end

  def self.down
    drop_attached_file :cte_keys, :asset
  end
end

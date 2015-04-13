class AddAttachmentAssetToNfeKeys < ActiveRecord::Migration
  def self.up
    change_table :nfe_keys do |t|
      t.attachment :asset
    end
  end

  def self.down
    drop_attached_file :nfe_keys, :asset
  end
end

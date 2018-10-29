class AddAttachmentAssetToNfeXmls < ActiveRecord::Migration[5.0]
  def self.up
    change_table :nfe_xmls do |t|
      t.attachment :asset
    end
  end

  def self.down
    drop_attached_file :nfe_xmls, :asset
  end
end

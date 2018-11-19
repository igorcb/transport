class AddAttachmentAvatarToDrivers < ActiveRecord::Migration[5.0]
  def self.up
    change_table :drivers do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :drivers, :avatar
  end
end

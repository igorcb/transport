class AddAttachmentAvatarToEmployees < ActiveRecord::Migration[5.0]
  def self.up
    change_table :employees do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :employees, :avatar
  end
end

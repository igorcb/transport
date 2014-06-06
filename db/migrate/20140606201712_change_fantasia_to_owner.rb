class ChangeFantasiaToOwner < ActiveRecord::Migration
  def self.up
    change_table :owners do |t|
      t.change :fantasia, :string, limit: 100, null: false
    end
  end
  def self.down
    change_table :owners do |t|
      t.change :fantasia, :string, limit: 18, null: false
    end
  end
end

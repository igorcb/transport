class ChangeRemessaYpeTypeInNfeKeys < ActiveRecord::Migration
  def up
  	change_column :nfe_keys, :remessa_ype, :string, limit: 30
  end

  def down
  	change_column :nfe_keys, :remessa_ype, :integer
  end
end

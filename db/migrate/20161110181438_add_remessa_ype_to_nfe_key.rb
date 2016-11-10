class AddRemessaYpeToNfeKey < ActiveRecord::Migration
  def change
    add_column :nfe_keys, :remessa_ype, :integer
  end
end

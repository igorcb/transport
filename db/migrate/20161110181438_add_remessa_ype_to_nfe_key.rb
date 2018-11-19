class AddRemessaYpeToNfeKey < ActiveRecord::Migration[5.0]
  def change
    add_column :nfe_keys, :remessa_ype, :integer
  end
end

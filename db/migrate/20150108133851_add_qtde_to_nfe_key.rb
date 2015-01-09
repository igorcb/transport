class AddQtdeToNfeKey < ActiveRecord::Migration
  def change
    add_column :nfe_keys, :qtde, :integer, default: 0
  end
end

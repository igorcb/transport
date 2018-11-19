class AddQtdeToNfeKey < ActiveRecord::Migration[5.0]
  def change
    add_column :nfe_keys, :qtde, :integer, default: 0
  end
end

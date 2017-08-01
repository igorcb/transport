class AddNfeSourceTypeToNfeKeys < ActiveRecord::Migration
  def change
    add_column :nfe_keys, :nfe_source_type, :string
  end
end

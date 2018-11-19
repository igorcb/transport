class AddNfeSourceTypeToNfeKeys < ActiveRecord::Migration[5.0]
  def change
    add_column :nfe_keys, :nfe_source_type, :string
  end
end

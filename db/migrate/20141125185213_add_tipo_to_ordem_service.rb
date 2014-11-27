class AddTipoToOrdemService < ActiveRecord::Migration
  def up
    add_column :ordem_services, :tipo, :integer, default: 0
    execute "ALTER TABLE ordem_services ALTER COLUMN cte DROP NOT NULL"
    execute "ALTER TABLE ordem_services ALTER COLUMN danfe_cte DROP NOT NULL"
  end
  
  def down
    remove_column :ordem_services, :tipo
    execute "ALTER TABLE ordem_services ALTER COLUMN cte SET NOT NULL"
    execute "ALTER TABLE ordem_services ALTER COLUMN danfe_cte SET NOT NULL"
  end
end

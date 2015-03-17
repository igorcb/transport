class ChangePlacaToOrdemServices < ActiveRecord::Migration
  def up
    execute "ALTER TABLE ordem_services ALTER COLUMN placa DROP NOT NULL;"
    execute "ALTER TABLE nfe_keys ALTER COLUMN chave DROP NOT NULL;"
  end

  def down
    execute "ALTER TABLE ordem_services ALTER COLUMN placa SET NOT NULL;"
    execute "ALTER TABLE nfe_keys ALTER COLUMN chave SET NOT NULL;"
  end
end

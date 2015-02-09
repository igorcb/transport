class ChangeColumEmailDestinoToComment < ActiveRecord::Migration
  def up
    execute "ALTER TABLE comments ALTER COLUMN email_destino TYPE character varying;"
  end
  
  def down
    execute "ALTER TABLE comments ALTER COLUMN email_destino TYPE character varying(255);"
  end
end

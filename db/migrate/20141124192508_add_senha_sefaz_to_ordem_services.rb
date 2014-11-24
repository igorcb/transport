class AddSenhaSefazToOrdemServices < ActiveRecord::Migration
  def change
    add_column :ordem_services, :senha_sefaz, :string, limit: 15
  end
end

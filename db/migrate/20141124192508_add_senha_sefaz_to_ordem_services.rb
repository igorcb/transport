class AddSenhaSefazToOrdemServices < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_services, :senha_sefaz, :string, limit: 15
  end
end

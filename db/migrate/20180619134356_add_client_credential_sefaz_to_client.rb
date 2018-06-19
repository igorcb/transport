class AddClientCredentialSefazToClient < ActiveRecord::Migration
  def change
    add_column :clients, :client_credential_sefaz, :boolean, default: false
  end
end

class AddClientCredentialSefazToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :client_credential_sefaz, :boolean, default: false
  end
end

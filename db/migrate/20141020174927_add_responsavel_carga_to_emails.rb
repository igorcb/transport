class AddResponsavelCargaToEmails < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :responsavel_carga, :boolean, defaulf: false
  end
end

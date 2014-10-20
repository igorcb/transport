class AddResponsavelCargaToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :responsavel_carga, :boolean, defaulf: false
  end
end

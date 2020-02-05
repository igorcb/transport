class AddDevolutionToNfeXmls < ActiveRecord::Migration[5.1]
  def change
    add_column :nfe_xmls, :devolution, :boolean
    add_column :nfe_xmls, :number_nfo, :string
    add_column :nfe_xmls, :chave_nfo, :string
  end
end

class ChangeBrackdownNfeXmls < ActiveRecord::Migration[5.1]
  def change
    add_column :breakdown_nfe_xmls, :sobras, :integer
    add_column :breakdown_nfe_xmls, :faltas, :integer
    add_column :breakdown_nfe_xmls, :type_breakdown, :integer
    add_column :breakdown_nfe_xmls, :unid_medida, :string
    rename_column :breakdown_nfe_xmls, :qtde, :avarias
    change_column :breakdown_nfe_xmls, :avarias, :integer
  end
end

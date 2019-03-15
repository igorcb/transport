class AddIssueDateToNfeXmls < ActiveRecord::Migration[5.1]
  def change
    add_column :nfe_xmls, :issue_date, :date
  end
end

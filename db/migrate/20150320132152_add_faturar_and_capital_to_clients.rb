class AddFaturarAndCapitalToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :faturar, :boolean
    add_column :clients, :capital, :boolean
  end
end

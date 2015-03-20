class AddFaturarAndCapitalToClients < ActiveRecord::Migration
  def change
    add_column :clients, :faturar, :boolean
    add_column :clients, :capital, :boolean
  end
end

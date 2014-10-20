class CreateGroupClients < ActiveRecord::Migration
  def change
    create_table :group_clients do |t|
      t.string :descricao

      t.timestamps
    end
  end
end

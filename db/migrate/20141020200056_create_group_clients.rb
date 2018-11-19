class CreateGroupClients < ActiveRecord::Migration[5.0]
  def change
    create_table :group_clients do |t|
      t.string :descricao

      t.timestamps
    end
  end
end

class CreateClientRepresentatives < ActiveRecord::Migration[5.0]
  def change
    create_table :client_representatives do |t|
      t.references :client, index: true
      t.references :representative, index: true

      t.timestamps
    end
  end
end

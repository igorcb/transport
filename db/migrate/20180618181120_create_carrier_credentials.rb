class CreateCarrierCredentials < ActiveRecord::Migration[5.0]
  def change
    create_table :carrier_credentials do |t|
      t.references :carrier_source, foreign_key: {to_table: :users }
      t.references :carrier_credential, foreign_key: {to_table: :users }

      t.timestamps
    end
  end
end

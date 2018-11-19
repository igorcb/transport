class AddManifestoToBoarding < ActiveRecord::Migration[5.0]
  def change
    add_column :boardings, :manifesto, :string, limit: 20
    add_column :boardings, :chave_manifesto, :string, limit: 45
  end
end

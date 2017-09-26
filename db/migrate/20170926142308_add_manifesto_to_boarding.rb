class AddManifestoToBoarding < ActiveRecord::Migration
  def change
    add_column :boardings, :manifesto, :string, limit: 20
    add_column :boardings, :chave_manifesto, :string, limit: 45
  end
end

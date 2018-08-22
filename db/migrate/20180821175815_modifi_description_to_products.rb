class ModifiDescriptionToProducts < ActiveRecord::Migration
  def change
    change_column :products, :descricao, :string, :limit => 255
  end
end

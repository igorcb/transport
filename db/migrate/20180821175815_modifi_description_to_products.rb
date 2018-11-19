class ModifiDescriptionToProducts < ActiveRecord::Migration[5.0]
  def change
    change_column :products, :descricao, :string, :limit => 255
  end
end

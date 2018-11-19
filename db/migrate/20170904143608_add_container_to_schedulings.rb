class AddContainerToSchedulings < ActiveRecord::Migration[5.0]
  def change
    add_column :schedulings, :container, :string
    add_column :schedulings, :obs, :text
  end
end

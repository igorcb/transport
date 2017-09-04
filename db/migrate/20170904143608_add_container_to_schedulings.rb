class AddContainerToSchedulings < ActiveRecord::Migration
  def change
    add_column :schedulings, :container, :string
    add_column :schedulings, :obs, :text
  end
end

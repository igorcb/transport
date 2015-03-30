class AddSuframaToClient < ActiveRecord::Migration
  def change
    add_column :clients, :suframa, :string, limit: 20
  end
end

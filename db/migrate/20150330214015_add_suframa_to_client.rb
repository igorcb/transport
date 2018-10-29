class AddSuframaToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :suframa, :string, limit: 20
  end
end

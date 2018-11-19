class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :email_origem
      t.string :email_destino, :limit => nil
      t.text :content
      t.references :comment, polymorphic: true, index: true

      t.timestamps
    end
  end
end

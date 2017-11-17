class CreateConfigSystems < ActiveRecord::Migration
  def change
    create_table :config_systems do |t|
      t.string :config_key
      t.string :config_value
      t.text :config_description

      t.timestamps
    end
  end
end

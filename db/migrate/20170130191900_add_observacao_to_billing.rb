class AddObservacaoToBilling < ActiveRecord::Migration[5.0]
  def change
    add_column :billings, :observacao, :text
  end
end

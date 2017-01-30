class AddObservacaoToBilling < ActiveRecord::Migration
  def change
    add_column :billings, :observacao, :text
  end
end

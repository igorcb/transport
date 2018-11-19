class AddChaveDanfeDevolucaoToOperating < ActiveRecord::Migration[5.0]
  def change
    add_column :operatings, :chave_danfe_devolucao, :string, limit: 45
  end
end

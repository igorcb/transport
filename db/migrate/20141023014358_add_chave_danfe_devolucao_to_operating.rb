class AddChaveDanfeDevolucaoToOperating < ActiveRecord::Migration
  def change
    add_column :operatings, :chave_danfe_devolucao, :string, limit: 45
  end
end

class AddTipoOperacaoToAccountBanks < ActiveRecord::Migration
  def change
    add_column :account_banks, :tipo_operacao, :integer
  end
end

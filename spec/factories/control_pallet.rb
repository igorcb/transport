FactoryBot.define do
  factory :control_pallet do
    data {Date.current}
    qte {rand (1..10)}
    tipo {:credito}
    historico {"HISTORICO PARA TESTE"}
    status {:open}
    # responsible_type
    # responsible_id
    type_product {:pallet}
  end
end

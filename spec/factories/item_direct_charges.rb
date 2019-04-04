FactoryBot.define do
  factory :item_direct_charge do
    direct_charge { nil }
    product { nil }
    number_nfe { "MyString" }
    qtde { "9.99" }
    qtde_trib { "9.99" }
    unid_medida { "MyString" }
    valor { "9.99" }
    valor_unitario { "9.99" }
    valor_unitario_comer { "9.99" }
  end
end

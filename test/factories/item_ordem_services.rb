# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_ordem_service do
    ordem_service nil
    product nil
    number "MyString"
    qtde "9.99"
    unid_medida "MyString"
    valor "9.99"
    qtde_trib "9.99"
    valor_unitario_comer "9.99"
    valor_unitario "9.99"
  end
end

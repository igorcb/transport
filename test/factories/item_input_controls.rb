# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_input_control do
    input_control nil
    product nil
    number_nfe "MyString"
    qtde "9.99"
    unid_medida "MyString"
    valor "9.99"
    valor_unitario "9.99"
    valor_unitario_comer "9.99"
  end
end

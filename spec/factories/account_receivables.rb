# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account_receivable do
    client nil
    cost_center nil
    sub_cos_center nil
    historic nil
    data_vencimento "2015-03-20"
    documento "MyString"
    valor "9.99"
    observacao "MyText"
    status 1
  end
end

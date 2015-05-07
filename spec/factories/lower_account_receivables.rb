# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lower_account_receivable do
    account_receivable nil
    cash_account nil
    data_pagamento "2015-05-07"
    valor_pago "MyString"
    juros "MyString"
    desconto "MyString"
    total_pago "9.99"
  end
end

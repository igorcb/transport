# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :control_pallet do
    client nil
    data "2016-06-09"
    qte 1
    tipo 1
    historico "MyString"
  end
end

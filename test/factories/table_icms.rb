# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :table_icm, :class => 'TableIcms' do
    state_source "MyString"
    state_target "MyString"
    aliquot "9.99"
  end
end

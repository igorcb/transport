# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :nfs_key do
    nfs "MyString"
    chave "MyString"
    nfs_id 1
    nfs_type "MyString"
  end
end

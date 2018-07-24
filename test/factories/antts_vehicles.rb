# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :antts_vehicle, :class => 'AnttsVehicles' do
    antt nil
    vehicle nil
  end
end

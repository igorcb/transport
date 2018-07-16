# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :micro_regions_city, :class => 'MicroRegionsCities' do
    micro_region nil
    city nil
  end
end

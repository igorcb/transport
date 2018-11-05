FactoryBot.define do
  factory :boarding do
    carrier
    driver
    status {Boarding::TipoStatus::ABERTO}
  end
end

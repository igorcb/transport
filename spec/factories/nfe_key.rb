FactoryBot.define do
  number_chave = (0...44).map { rand(0..9) }.join
  factory :nfe_key do
    nfe { (0...9).map { rand(0..9) }.join }
    chave { number_chave }
    nfe_id {1}
    nfe_type {"OrdemService"}
  end
end

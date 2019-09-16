FactoryBot.define do
  factory :conference_item do
    conference { nil }
    product { "" }
    qtde_oper { 1 }
    qtde_sup { 1 }
    avaria { 1 }
    falta { 1 }
    sobra { 1 }
  end
end

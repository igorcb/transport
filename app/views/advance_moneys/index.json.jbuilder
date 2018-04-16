json.array!(@advance_moneys) do |advance_money|
  json.extract! advance_money, :id, :date_advance, :number, :price
  json.url advance_money_url(advance_money, format: :json)
end

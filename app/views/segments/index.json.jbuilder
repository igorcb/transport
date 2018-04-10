json.array!(@segments) do |segment|
  json.extract! segment, :id, :name
  json.url segment_url(segment, format: :json)
end

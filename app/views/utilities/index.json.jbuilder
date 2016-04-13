json.array!(@utilities) do |utility|
  json.extract! utility, :id
  json.url utility_url(utility, format: :json)
end

json.array!(@occupants) do |occupant|
  json.extract! occupant, :id
  json.url occupant_url(occupant, format: :json)
end

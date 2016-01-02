json.array!(@bands) do |band|
  json.extract! band, :id, :name, :website
  json.url band_url(band, format: :json)
end

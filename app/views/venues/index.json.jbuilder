json.array!(@venues) do |venue|
  json.extract! venue, :id, :name, :city, :street, :zip, :website, :longitude, :latitude
  json.url venue_url(venue, format: :json)
end

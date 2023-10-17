geocoder = GeocoderService.new

["Chicago", "Los Angeles", "San Francisco"].each do |city|
  entry = geocoder.geocode(city)
  fail "Cant find geocoder data for #{city}!" unless entry

  location = LocationService.import(entry)
  puts "Imported #{location.display_name}"

  puts "Fetching weather data"
  Locations::CurrentForecastJob.perform_now(location.id)
  Locations::ExtendedForecastJob.perform_now(location.id)
end

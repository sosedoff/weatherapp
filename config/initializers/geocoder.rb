Geocoder.configure(
  lookup: :nominatim,
  http_headers: { "User-Agent" => "weatherapp (your_email@example.com)" },
  timeout: 5
) 

Geocoder.configure(
  lookup: :nominatim,
  http_headers: { "User-Agent" => "weather-lookup-app (sumityadavna@gmail.com)" },
  timeout: 5
)

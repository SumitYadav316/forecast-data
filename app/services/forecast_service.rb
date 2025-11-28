require "ostruct"
require "httparty"

class ForecastService
  CACHE_EXPIRY = 30.minutes

  def initialize(query)
    @query = query.to_s.strip
  end

  def call
    return failure("Blank address") if @query.blank?

    cache_key = "forecast:#{@query.parameterize}"
    result = Rails.cache.fetch(cache_key, expires_in: CACHE_EXPIRY) do
      data = fetch_forecast
      { fetched_at: Time.current.utc, data: data }
    end

    OpenStruct.new(
      success?: result[:data].present?,
      data: result[:data],
      fetched_at: result[:fetched_at],
      from_cache: result[:fetched_at] < 1.minute.ago,
      error: (result[:data].nil? ? "Unable to fetch forecast." : nil)
    )
  end

  private

  def fetch_forecast
    geocoded = Geocoder.search(@query).first
    return nil unless geocoded

    lat = geocoded.latitude
    lon = geocoded.longitude
    location_name = [geocoded.city, geocoded.state, geocoded.country].compact.join(", ")

    api_key = ENV["OPENWEATHER_API_KEY"]
    return nil if api_key.blank?

    url = "https://api.openweathermap.org/data/2.5/onecall"
    query = {
      lat: lat,
      lon: lon,
      units: "metric",
      exclude: "minutely,alerts",
      appid: api_key
    }

    response = HTTParty.get(url, query: query)
    body = JSON.parse(response.body)

    {
      location_name: location_name.presence || geocoded.address,
      timezone: body["timezone"],
      current: {
        temp: body.dig("current", "temp"),
        feels_like: body.dig("current", "feels_like"),
        humidity: body.dig("current", "humidity"),
        weather: body.dig("current", "weather", 0, "description")
      },
      daily: (body["daily"] || []).first(7).map do |d|
        {
          dt: Time.at(d["dt"]).to_date,
          temp_min: d.dig("temp", "min"),
          temp_max: d.dig("temp", "max"),
          weather: d.dig("weather", 0, "description")
        }
      end
    }
  rescue => e
    Rails.logger.error("Forecast error: #{e.message}")
    nil
  end

  def failure(msg)
    OpenStruct.new(success?: false, data: nil, error: msg)
  end
end

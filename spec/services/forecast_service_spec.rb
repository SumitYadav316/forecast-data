require "rails_helper"

RSpec.describe ForecastService do
  let(:query)     { "Indore" }
  let(:api_key)   { "fake_api_key" }
  let(:geocode_response) do
    [OpenStruct.new(
      latitude: 22.72,
      longitude: 75.85,
      city: "Indore",
      state: "MP",
      country: "India",
      address: "Indore, MP, India"
    )]
  end

  before do
    ENV["OPENWEATHER_API_KEY"] = api_key
    allow(Geocoder).to receive(:search).and_return(geocode_response)
    stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall")
	  .with(query: hash_including({
	    "lat" => 22.72,
	    "lon" => 75.85,
	    "units" => "metric",
	    "exclude" => "minutely,alerts",
	    "appid" => "fake_api_key"
	  }))
	  .to_return(
	    status: 200,
	    body: {
	      timezone: "Asia/Kolkata",
	      current: {
	        temp: 30,
	        feels_like: 32,
	        humidity: 60,
	        weather: [{ description: "clear sky" }]
	      },
	      daily: []
	    }.to_json,
	    headers: { "Content-Type" => "application/json" }
	  )

  end

  it "returns forecast data successfully" do
    result = ForecastService.new(query).call

    expect(result.success?).to eq(true)
    expect(result.data[:location_name]).to eq("Indore, MP, India")
    expect(result.data[:current][:temp]).to eq(30)
    expect(result.data[:daily].length).to eq(1)
  end

  it "fails when geocoder returns nothing" do
    allow(Geocoder).to receive(:search).and_return([])

    result = ForecastService.new(query).call
    expect(result.success?).to eq(false)
  end

  it "fails when API key is missing" do
    ENV["OPENWEATHER_API_KEY"] = nil
    result = ForecastService.new(query).call
    expect(result.success?).to eq(false)
  end
end

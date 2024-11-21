require 'rails_helper'

RSpec.describe WeatherService do
  before (:each) do
    Rails.cache.clear
  end

  describe '#call' do
    it 'returns result from API if no cache is available' do
      stub_request(:any, /api.weatherstack.com/).
        to_return_json(body: { "location": {
                                   "name": "Chicago"
                               },
                              "current": {
                                  "temperature": 41,
                                  "feelslike": 37
                              }
                            })
      expect(WeatherService.call('60616')).to eq({ location_name: "Chicago",
                                                   temperature: 41,
                                                   feelslike: 37 })
    end

    it 'returns cached version if available' do
      Rails.cache.write('60616', { "location_name": "Chicago", "temperature": 41, "feelslike": 37 }.to_json)
      expect(WeatherService.call('60616')).to eq({ location_name: "Chicago",
                                                   temperature: 41,
                                                   feelslike: 37,
                                                   from_cache: true })
    end

    it 'returns nil if request fails' do
      stub_request(:any, /api.weatherstack.com/).
        to_return_json(body: { error: 'message' })
      expect(WeatherService.call('60616')).to be_nil
    end

    it 'returns nil if passed an invalid zipcode' do
      expect(WeatherService.call('0')).to be_nil
    end
  end
end

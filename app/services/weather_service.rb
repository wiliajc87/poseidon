class WeatherService < ApplicationService
  CACHE_TIMEOUT = 30.minutes.freeze

  def initialize(zipcode)
    @zipcode = zipcode
  end

  def call
    return nil if invalid_zipcode_format?

    return weather_with_cache_flag(Rails.cache.read(@zipcode)) if Rails.cache.read(@zipcode)

    weather_response = make_weather_request

    if weather_response
      format_and_cache_weather_response(weather_response)
    else
      nil
    end
  end

  private

  def invalid_zipcode_format?
    !(/^\d{5}(-\d{4})?$/.match?(@zipcode.to_s))
  end

  # Returns results or nil if request fails
  def make_weather_request
    # https://weatherstack.com/documentation#current_weather
    response = HTTParty.get("http://api.weatherstack.com/current?access_key=#{ENV['WEATHER_API_KEY']}&units=f&query=#{@zipcode}")
    # Weatherstack returns a :200 even if there is an error, so weather_request_response.success? would be a false lead
    # In a production setting this would be more complex--we'd log the various possible error types and build alarms based on them
    !response["error"].present? ? response : nil
  end

  def format_and_cache_weather_response(weather_response)
    formatted_weather = selected_weather_fields(weather_response)
    Rails.cache.write(@zipcode, formatted_weather.to_json, expires_in: CACHE_TIMEOUT)
    formatted_weather
  end

  def selected_weather_fields(response)
    { location_name: response["location"]["name"],
      temperature: response["current"]["temperature"],
      feelslike: response["current"]["feelslike"] }
  end

  def weather_with_cache_flag(display_object)
    updated_object = JSON.parse(display_object)
    updated_object["from_cache"] = true
    updated_object.symbolize_keys
  end
end

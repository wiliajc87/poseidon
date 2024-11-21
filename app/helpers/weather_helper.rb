module WeatherHelper
  def displayed_weather(weather_results)
    result = "The current temperature in #{weather_results[:location_name]} is #{weather_results[:temperature]}° and it feels like #{weather_results[:feelslike]}°. "
    result += "(results cached)" if weather_results[:from_cache]
    result
  end
end

class WeatherController < ApplicationController
  def input; end

  def display
    @weather_results = WeatherService.call(params["zipcode"])

    unless @weather_results
      flash[:error] = "Something went wrong!"
      redirect_to "/"
    end
  end
end

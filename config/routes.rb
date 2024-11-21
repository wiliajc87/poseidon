Rails.application.routes.draw do
  root "weather#input"
  get "/display", to: "weather#display"
end

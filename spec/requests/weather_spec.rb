require 'rails_helper'

RSpec.describe "Weathers", type: :request do
  describe "GET /input" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /display" do
    before (:each) do
      Rails.cache.clear
    end

    it "returns http success" do
      stub_request(:any, /api.weatherstack.com/).
        to_return_json(body: { "location": {
                                   "name": "Chicago"
                               },
                              "current": {
                                  "temperature": 41,
                                  "feelslike": 37
                              }
                            })

      get "/display?zipcode=60616"
      expect(response).to have_http_status(:success)
    end

    it "redirects invalid zipcode" do
      stub_request(:any, /api.weatherstack.com/)
      get "/display?zipcode=0"
      expect(response).to redirect_to('/')
    end

    it "redirects invalid weather return" do
      stub_request(:any, /api.weatherstack.com/).
        to_return_json(body: { "error": 'message' })
      get "/display?zipcode=60616"
      expect(response).to redirect_to('/')
    end
  end
end

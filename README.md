
# Poseidon
An in-memory weather app

This application uses Rails 8.0.0 and Ruby version 3.2.3.

One should be able to run `bundle install` and then `rspec` to run the specs, `rails server` to run the server.

In order to use this project, one must have a Weatherstack (https://weatherstack.com/) API key for the different environments at `config/secrets.yml` in the following format:
```
development:
  weather_api_key: WEATHERSTACK_API_KEY

test: 
  weather_api_key: WEATHERSTACK_API_KEY

production:
  weather_api_key: WEATHERSTACK_API_KEY
```

This project utilizes Redis for non-disk memory, so you may need to run `redis-server` if you don't have that running locally. It is assumed Redis is running on your localhost, as defined at `config.cache_store = :redis_cache_store, { url: "redis://localhost:6379/0" }` in the `config/environments/development.rb` and `config/environments/test.rb` files. Specs write to Redis but wipe the Redis test env between each test.

Because the proposed application never relied on saved weather entries, I opted to rely only on Redise caching and wrote a WeatherService to handle making requests to Weatherstack and handling payloads. In an application that needed ActiveRecord models, I still would have *mostly* followed this pattern so as to keep the Weatherstack dependency away from the database and controller logic.

source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "pg", "~> 1.6"
gem "puma", ">= 5.0"
gem 'dotenv-rails', groups: [:development, :test]

# Rails 8
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"

  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "rubocop-rails-omakase", require: false

  # Documentation
  gem 'rswag'
  gem 'rswag-api'
  gem 'rswag-ui'
end

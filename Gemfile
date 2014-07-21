source 'https://rubygems.org'
ruby '2.0.0'

gem 'unicorn'
gem 'sinatra'
gem 'haml'
gem 'coffee-script'
gem 'therubyracer'

gem 'mongoid'

group :test, :development do
  gem 'rspec'
  gem 'factory_girl'

  gem 'rack-test'
end

group :production, :development do
  gem 'newrelic_rpm'
end

group :development do
  gem 'guard-rspec', require: false
end
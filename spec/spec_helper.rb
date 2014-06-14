ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler'
Bundler.require

require './factors_app'
require 'rspec'
require 'rack/test'
require 'factory_girl'

FactoryGirl.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before :all do
    Mongoid.purge!
  end
end
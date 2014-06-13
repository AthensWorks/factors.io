# config.ru (run with rackup)
require 'rubygems'
require 'bundler'
Bundler.require


require './factors_app'

run FactorsApp
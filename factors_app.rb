require 'rubygems'
require 'bundler/setup'
Bundler.require

Mongoid.load!("config/mongoid.yml")
I18n.config.enforce_available_locales=false
require "sinatra/namespace"
require './number'
require './lib/workers/factor_and_divisor_worker'
require './lib/pari_gp'
require './lib/delimited'

class FactorsApp < Sinatra::Base
  register Sinatra::Namespace

  get '/application.js' do
    coffee :'application'
  end

  # Homepage
  get '/' do
    haml :index
  end

  get '/about' do
    haml :about
  end

  # Get a random number
  get '/random' do
    random_number = rand(0..1_000_000_000_000_000_000_000)
    redirect to("/numbers/#{random_number}")
  end

  get '/random-prime' do
    random_value = Number.where(prime: true).pluck(:value).sample
    redirect to("/numbers/#{random_value}")
  end

  # Show a number
  get '/numbers/:number' do
    val = Number.ensure_integer_as_string(params[:number])
    number = Number.where(value: val).first || Number.new(value: val, status: 'incomplete')
    haml :'numbers/get', locals: { number: number}
  end

  # Submit a number
  post '/numbers/:number' do
    val = Number.ensure_integer_as_string(params[:number])
    number = Number.where(value: val).first || Number.create(value: val, status: 'incomplete')

    if number.status == 'incomplete'
      number.status = 'queued'
      number.save
      FactorAndDivisorWorker.perform_async(number.value)
    end

    redirect to("/numbers/#{val}")
  end

  namespace '/api' do
    get "/numbers/recent" do
      Number.order_by(created_at: :desc).limit(10).pluck(:value).to_json
    end

    get '/numbers/:number' do
      val = Number.ensure_integer_as_string(params[:number])
      number = Number.where(value: val).first || Number.new(value: val, status: 'incomplete')

      { value:     number.value,
        status:   number.status,
        factors:  number.factors,
        divisors: number.divisors,
        prime:    number.prime,
        factorization_duration: number.factorization_duration
      }.to_json
    end

    get '/random_number' do
      random_number = rand(0..1_000_000_000_000_000_000_000)
      redirect to("/api/numbers/#{random_number}")
    end

    get '/random-prime' do
      random_value = Number.where(prime: true).pluck(:value).sample
      redirect redirect to("/api/numbers/#{random_value}")
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
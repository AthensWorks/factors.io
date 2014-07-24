require 'rubygems'
require 'bundler/setup'
Bundler.require

Mongoid.load!("config/mongoid.yml")
I18n.config.enforce_available_locales=false
require "sinatra/namespace"
require './number'
require './lib/pari_gp'
require './lib/delimited'

class FactorsApp < Sinatra::Base
  register Sinatra::Namespace
  set :server, 'thin'

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
    # http://stackoverflow.com/a/21867984
    random_number = rand(0..1_000_000_000_000_000_000_000)
    redirect to("/factors/#{random_number}")
  end

  get '/random-prime' do
    all_primes_ids = Number.where(prime: true).pluck(:_id)
    random_id = all_primes_ids.sample

    redirect to("/factors/#{Number.find(random_id).value}")
  end

  # Show a number
  get '/factors/:number' do
    val = Number.ensure_integer_as_string(params[:number])
    number = Number.where(value: val).first || Number.new(value: val, status: 'incomplete')
    haml :'factors/get', locals: { number: number}
  end

  # Submit a number
  post '/factors/:number' do
    haml "TODO: POST /factors/#{params[:number]}"
  end

  namespace '/api' do
    get "/numbers/recent" do
      Number.order_by(created_at: :desc).limit(10).pluck(:value).to_json
    end

    get '/numbers/:number' do
      val = Number.ensure_integer_as_string(params[:number])
      number = Number.where(value: val).first || Number.new(value: val, status: 'incomplete')

      {value:     number.value,
        status:   number.status,
        factors:  number.factors,
        divisors: number.divisors,
        prime:    number.prime
      }.to_json
    end

    get '/random_number' do
      random_number = rand(0..1_000_000_000_000_000_000_000)
      redirect to("/api/numbers/#{random_number}")
    end

    get '/random_prime' do
      all_prime_ids = Number.where(prime: true).pluck(:_id)
      random_id = all_prime_ids.sample
      redirect redirect to("/api/numbers/#{Number.find(random_id).value}")
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
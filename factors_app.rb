Mongoid.load!("config/mongoid.yml")
I18n.config.enforce_available_locales=false
require './number'

class FactorsApp < Sinatra::Base
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
    number = Number.where(value: val).first || Number.new(value: val)
    haml :'factors/get', locals: { number: number}
  end


  # Submit a number
  post '/factors/:number' do
    haml "TODO: POST /factors/#{params[:number]}"
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
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

  # Show a number
  get '/factors/:number' do
    number = params[:number].to_i
    haml :'factors/get', locals: { number: number}
  end

  # Submit a number
  post '/factors/:number' do
    haml "TODO: POST /factors/#{params[:number]}"
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
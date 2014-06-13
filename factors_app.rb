class FactorsApp < Sinatra::Base

  # Homepage
  get '/' do
    "Hello Factorized World"
  end

  get '/about' do
    "Who built this? And why?"
  end

  # Get a random number
  get '/random' do
    "TODO: GET /random"
  end

  # Show a number
  get '/factors/:number' do
    "TODO: GET /factors/#{params[:number]}"
  end

  # Submit a number
  post '/factors/:number' do
    "TODO: POST /factors/#{params[:number]}"
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
class FactorsApp < Sinatra::Base

  # Homepage
  get '/' do
    "Hello Factorized World"
  end

  # Get a random number
  get '/random' do
  end

  # Show a number
  get '/factors/:number' do
  end

  # Submit a number
  post '/factors/:number' do
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end
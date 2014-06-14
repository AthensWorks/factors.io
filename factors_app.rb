class FactorsApp < Sinatra::Base
  set :server, 'thin'

  # Homepage
  get '/' do
    haml :index
  end

  get '/about' do
    haml :about
  end

  # Get a random number
  get '/random' do
    erb "TODO: GET /random"
  end

  # Show a number
  get '/factors/:number' do
    number = params[:number].to_i
    haml :'factors/get', locals: { number: number}
  end

  # Submit a number
  post '/factors/:number' do
    erb "TODO: POST /factors/#{params[:number]}"
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
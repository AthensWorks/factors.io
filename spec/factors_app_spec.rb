require 'spec_helper'

describe 'Factor App' do
  it "has a home page" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Hello Factorized World')
  end

  it "has an about page" do
    get '/about'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Ricky')
    expect(last_response.body).to include('Kahtan')
  end

  it "has a random page, which takes you to a /factors show page" do
    get '/random'
    follow_redirect!

    expect(last_response).to be_ok
    expect(last_response.body).to include('Factors for:')
  end

  it "has a /factors show page" do
    random_number = rand(0..1_000_000_000_000_000_000).to_s

    get "/factors/#{random_number}"
    expect(last_response).to be_ok
    expect(last_response.body).to include('Factors for:')
    expect(last_response.body).to include(random_number)
  end

  it "shows factors for a specific number" do
    val = "40"
    factors = ["1", "2", "4", "5", "8", "10", "20", "40"]
    FactoryGirl.create(:number, value: val, factors: factors)

    get "/factors/40"
    expect(last_response).to be_ok
    expect(last_response.body).to include('Factors for:')
    expect(last_response.body).to include('40')

    factors.each do |factor|
      expect(last_response.body).to include(factor)
      expect(last_response.body).to include("/factors/#{factor}")
    end
  end

  pending "has a POST /factors page" do

    random_number = rand(0..1_000_000_000_000_000_000).to_s
    email = 'test@factors.io'

    post "/factors/#{random_number}?email=#{email}"

    expect(last_response).to be_ok
    expect(last_response.body).to include('Thank you')
    expect(last_response.body).to include('We will email you when')
    expect(last_response.body).to include(random_number)
  end
end
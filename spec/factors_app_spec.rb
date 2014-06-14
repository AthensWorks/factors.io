require 'spec_helper'

describe 'Factor App' do
  def app
    Sinatra::Application
  end

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Hello Factorized World')
  end
end
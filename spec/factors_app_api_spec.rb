require 'spec_helper'

describe 'Factor App API' do
  before(:each) do
    Number.destroy_all
  end

  it "returns json for a given number" do
    num = FactoryGirl.create(:number)

    get "/api/numbers/#{num.value}"

    parsed_result = JSON.parse(last_response.body)
    expect(last_response).to be_ok
    expect(parsed_result).to be_a Hash
    expect(parsed_result["value"]).to    eq num.value
    expect(parsed_result["factors"]).to  eq num.factors
    expect(parsed_result["divisors"]).to eq num.divisors
    expect(parsed_result["prime"]).to    eq num.prime
    expect(parsed_result["factorization_duration"]).to eq num.factorization_duration
  end

  pending "returns json for (up to) the most recent 10 values" do
    numbers = FactoryGirl.create_list(:number_with_random_value, 10)

    get "/api/numbers/recent"

    parsed_result = JSON.parse(last_response.body)
    expect(last_response).to be_ok
    expect(parsed_result).to be_a Array

    numbers.each_with_index do |number, index|
      puts "#{index} #{number.value}"
      expect(parsed_result[index]).to eq number.value
    end
  end
end
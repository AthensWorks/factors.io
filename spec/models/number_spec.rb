require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Number do
  it "should allow you to create a number" do
    number = FactoryGirl.build(:number)
    expect(number.valid?).to be true
  end

  it "should require status to be set" do
    number = FactoryGirl.build(:number, status: nil)
    expect(number.valid?).to be false
  end

  it "should require value to be set" do
    number = FactoryGirl.build(:number, value: nil)
    expect(number.valid?).to be false
  end

  it "should require value an Integer-like string" do
    number = FactoryGirl.build(:number, value: "123ab45")
    expect(number.valid?).to be false
  end

  it "should require a known status" do
    number = FactoryGirl.build(:number, status: 'unknown')
    expect(number.valid?).to be false
  end

  it "should require a status" do
    number = FactoryGirl.build(:number, status: nil)
    expect(number.valid?).to be false
  end

  it "should allow on specific statuses" do
    number = FactoryGirl.build(:number)

    number.status = 'complete'
    expect(number.valid?).to be true

    number.status = 'in-progress'
    expect(number.valid?).to be true

    number.status = 'queued'
    expect(number.valid?).to be true

    number.status = 'incomplete'
    expect(number.valid?).to be true
  end

  it "should have hash-like facotrs" do
    number = FactoryGirl.build(:number, factors: {})
    expect(number.factors?).to be false
    expect(number.factors.keys).to eq []

    number = FactoryGirl.build(:number, factors: {'2' => '3', '5' => '4'})
    expect(number.factors?).to be true
    expect(number.factors['2']).to eq '3'
    expect(number.factors['5']).to eq '4'
  end

  it "should have an array of divisors" do
    number = FactoryGirl.build(:number, divisors: [])
    expect(number.divisors?).to be false
    expect(number.divisors).to eq []

    number = FactoryGirl.build(:number, divisors: ['1', '2', '4', '5', '10', '20'])
    expect(number.divisors?).to be true
    expect(number.divisors.size).to eq 6
  end

  it "should know about primality" do
    number = FactoryGirl.build(:number, value: '5', prime: true)
    expect(number.prime?).to be true

    number = FactoryGirl.build(:number, value: '20', prime: false)
    expect(number.prime?).to be false
  end

  context "can only factor up to 50 digits" do
    it "should allow values up to 18 digits" do
      val = '1' * 50 # 18 digit integer
      number = FactoryGirl.build(:number, value: val)
      expect(number).to be_valid
    end

    it "should limit values to no more than 51 digits" do
      val = '1' * 51 # 51 digit integer
      number = FactoryGirl.build(:number, value: val)
      expect(number).to_not be_valid
    end

  end
end
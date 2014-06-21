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

  it "#has_factors?" do
    number = FactoryGirl.build(:number, factors: [])
    expect(number.has_factors?).to be false

    number = FactoryGirl.build(:number, factors: [1, 2])
    expect(number.has_factors?).to be true
  end

  context "can only factor up to 18 digits" do
    it "should allow values up to 18 digits" do
      val = '1' * 18 # 18 digit integer
      number = FactoryGirl.build(:number, value: val)
      expect(number).to be_valid
    end

    it "should limit values to no more than 18 digits" do
      val = '1' * 19 # 19 digit integer
      number = FactoryGirl.build(:number, value: val)
      expect(number).to_not be_valid
    end

  end
end
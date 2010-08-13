require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Google Charts' extended data encoding" do
  it "should translate an integer to two characters" do
    ExtendedEncoding.new.translate(0).should == "AA"
    ExtendedEncoding.new.translate(25).should == "AZ"
    ExtendedEncoding.new.translate(26).should == "Aa"
    ExtendedEncoding.new.translate(62).should == "A-"
    ExtendedEncoding.new.translate(63).should == "A."
    ExtendedEncoding.new.translate(4095).should == ".."
  end

  it "should translate out of bounds numbers to '__'" do
    ExtendedEncoding.new.translate(4096).should == "__"
    ExtendedEncoding.new.translate(-1).should == "__"
  end

  it "should translate nil numbers to '__'" do
    ExtendedEncoding.new.translate(nil).should == "__"
  end

  it "should truncate floating point numbers to integers before encoding" do
    ExtendedEncoding.new.translate(1.1).should == "AB"
    ExtendedEncoding.new.translate(1.9).should == "AB"
  end

  it "should apply a translation to every number in an array" do
    ExtendedEncoding.new.apply([0,1,2]).should == "e:AAABAC"
  end

  it "should have a maximum value of 4095" do
    ExtendedEncoding.new.max.should == 4095
  end
end

describe "Data Encodingter (using the ExtendedEncoding)" do
  it "should return 1 if all values are between 0 and 4095" do
    DataEncoder.new([0, 4095, 666]).divisor.should == 1
  end

  it "should return a scaling factor if a value is bigger than 4095" do
    DataEncoder.new([0, 8190, 666]).divisor.should == 2
  end

  it "should return a scaling factor of 1 if the spread is 4095" do
    DataEncoder.new([4095, 8190, 5666]).divisor.should == 1
  end

  it "should return a scaling factor of 2 if the spread is 8190" do
    DataEncoder.new([-4095, 4095, 666]).divisor.should == 2
  end
  
  it "should return shift amount so that the lowest value will be 0" do
    DataEncoder.new([-4095, 4095, 666]).shift.should == 4095
    DataEncoder.new([4095, 8190, 5666]).shift.should == -4095
  end
  
  it "should scale every value in the array with fractional values rounded" do
    DataEncoder.new([-4095, 4095, 666]).scaled_data.should == [0, 4095, (2048 + 333)]
  end

  it "should call delegate #encode to SomeEncoding#apply with scaled data" do
    DataEncoder.new([0, 8190]).encode.should == "e:AA.."
  end

  it "should alias #to_s to #encode" do
    DataEncoder.new([0, 8190]).to_s.should == "e:AA.."
  end
end

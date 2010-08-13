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
    ExtendedEncoding.new.encode([0,1,2]).should == "e:AAABAC"
  end

  it "should have a maximum value of 4095" do
    ExtendedEncoding::MAX.should == 4095
  end
end


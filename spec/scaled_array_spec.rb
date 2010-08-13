require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ScaledArray" do
  it "should return 1 if all values are between 0 and 4095" do
    ScaledArray.new([0, 4095, 666], 4095).divisor.should == 1
  end

  it "should return 1/5 if all values are between 0 and 819" do
    ScaledArray.new([0, 819, 666], 4095).divisor.should == 0.2
  end

  it "should return a scaling factor if a value is bigger than 4095" do
    ScaledArray.new([0, 8190, 666], 4095).divisor.should == 2
  end

  it "should return a scaling factor of 1 if the spread is 4095" do
    ScaledArray.new([4095, 8190, 5666], 4095).divisor.should == 1
  end

  it "should return a scaling factor of 2 if the spread is 8190" do
    ScaledArray.new([-4095, 4095, 666], 4095).divisor.should == 2
  end
  
  it "should return offset amount so that the lowest value will be 0" do
    ScaledArray.new([-4095, 4095, 666], 4095).offset.should == 4095
    ScaledArray.new([4095, 8190, 5666], 4095).offset.should == -4095
  end
  
  it "should scale every value in the array with fractional values rounded" do
    ScaledArray.new([-4095, 4095, 666], 4095).scaled_data.should == [0, 4095, (2048 + 333)]
  end

  it "should delegate methods to array" do
    ScaledArray.new([-4095, 4095, 666], 4095).first.should == 0
  end
end

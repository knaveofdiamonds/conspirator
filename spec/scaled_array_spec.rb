require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ScaledArray" do
  it "should perform no scaling if the values exactly fill the granularity" do
    ScaledArray.new([0, 4095, 600], 4095).scale.should == [0, 4095, 600]
  end

  it "should halve values if they fill double the granularity" do
    ScaledArray.new([0, 8190, 600], 4095).scale.should == [0, 4095, 300]
  end

  it "should multiple values by 5 if they fill 1/5 of the granularity" do
    ScaledArray.new([0, 819, 600], 4095).scale.should == [0, 4095, 3000]
  end

  it "should offset values so the positive minimum value becomes 0" do
    ScaledArray.new([4095, 8190], 4095).scale.should == [0, 4095]
  end

  it "should offset values so the negative minimum value becomes 0" do
    ScaledArray.new([-4095, 0], 4095).scale.should == [0, 4095]
  end

  it "should offset values and scale them at the same time" do
    ScaledArray.new([-4095, 4095, 5], 4095).scale.should == [0, 4095, 2050]
  end
  
  it "should round fractional values when scaling" do
    ScaledArray.new([-4095, 4095, 600], 4095).scale.should == [0, 4095, (2048 + 300)]
  end

  it "should allow overriding the maximum value considered when scaling" do
    ScaledArray.new([0, 4095, 600], 4095).scale(:max => 8190).should == [0, 2048, 300]
  end

  it "should allow overriding the minimum value considered when scaling" do
    ScaledArray.new([0, 4095, 600], 4095).scale(:min => -4095).should == [2048, 4095, 2048 + 300]
  end

  it "should allow overriding both minimum and maximum" do
    ScaledArray.new([2, -2], 4095).scale(:max => 4095, :min => -4095).should == [2049,2047]
  end

  # This makes sense because the encoding should pick them up as undefined
  it "should return out of bounds results" do
    ScaledArray.new([0, 200], 4095).scale(:max => 100).should == [0, 8190]
  end

  it "should not corrupt internal state such that defaults don't get used" do
    a = ScaledArray.new([0, 4095, 600], 4095)
    a.scale(:max => 8190)
    a.scale.should == [0, 4095, 600]
  end
end

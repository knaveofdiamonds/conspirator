require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Summary statistics" do
  it "should return the maximum of a set of data" do
    SummaryStatistics.summarize([1,2,3,5,9,3]).max.should == 9
  end

  it "should return the minimum of a set of data" do
    SummaryStatistics.summarize([1,2,3,5,9,3]).min.should == 1
  end

  it "should return the difference between smallest and largest value as the range" do
    SummaryStatistics.summarize([1,2,9,5,3,4]).range.should == 8
  end

  context "with an odd sized data set" do
    before :each do
      @data = [6, 47, 49, 15, 42, 41, 7, 39, 43, 40, 36]
    end

    it "should return the middle value of an odd-sized list as the median" do
      SummaryStatistics.summarize(@data).median.should == 40
    end
    
    it "should return the first quartile" do
      SummaryStatistics.summarize(@data).first_quartile.should == 15
    end

    it "should return the fourth quartile" do
      SummaryStatistics.summarize(@data).third_quartile.should == 43
    end

    it "should return the interquartile range" do
      SummaryStatistics.summarize(@data).interquartile_range.should == 28
    end
  end

  context "with an even sized data set" do
    before :each do
      @data = [7, 15, 36, 39, 40, 41]
    end

    it "should return the average of the middle values of an even-sized list as the median" do
      SummaryStatistics.summarize(@data).median.should == 37.5
    end

    it "should calculate the first quartile (using SAS Method 4)" do
      SummaryStatistics.summarize(@data).first_quartile.should == 13
    end

    it "should calculate the third quartile (using SAS Method 4)" do
      SummaryStatistics.summarize(@data).third_quartile.should == 40.25
    end
  end
end

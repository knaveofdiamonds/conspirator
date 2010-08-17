module Conspirator
  # See http://www.haiweb.org/medicineprices/manual/quartiles_iTSS.pdf
  # for discussion surrounding calculating quartiles.
  #
  class SummaryStatistics
    attr_reader :max, :min, :range
    attr_reader :median, :first_quartile, :third_quartile, :interquartile_range

    # Creates a new set of summary statistics for a set of data.
    #
    # If the data is already sorted, pass the :presorted symbol as the
    # second parameter.
    def self.summarize(data, presorted=nil)
      new(data, presorted == :presorted)
    end

    def initialize(data, presorted=false)
      @data   = presorted ? data : data.sort
      @max    = data.max
      @min    = data.min
      @median = percentile(50)
      @first_quartile = percentile(25)
      @third_quartile = percentile(75)
      @range = @max - @min
      @interquartile_range = @third_quartile - @first_quartile
    end

    # Returns the pth percentile of the data set.
    #
    # For example data.percentile(50) == data.median
    #
    # This uses SAS Method 4 to calculate the percentiles.
    def percentile(p)
      x = (@data.size + 1) * (p / 100.0)
      j = x.floor
      g = x - j

      (1 - g) * @data[j - 1] + g * @data[j]
    end
  end
end

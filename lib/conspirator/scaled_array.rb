module Conspirator
  # Scales an Array of data to fit within encoding limits.
  class ScaledArray
    # Wraps an array and scales the values between 0 and the maximum
    #
    # If the data array is changed after using this encoder, the
    # behaviour is undefined.
    #
    def initialize(data, max_granularity)
      @data = data
      @default_max = data.max
      @default_min = data.min
      @max_granularity = max_granularity
    end

    # Applies scaling to the array of data.
    def scale(opts={})
      @max = opts[:max] || @default_max
      @min = opts[:min] || @default_min
      @data.map {|x| ((x + offset) / divisor).round }
    end

    private

    # Returns the number data will be divided by to fit within encoding limits.
    def divisor
      spread / @max_granularity.to_f
    end

    # Returns the amount values have to be offset so the minimum value
    # equates to zero.
    def offset
      0 - @min
    end

    # Returns the spread of the data.
    def spread
      @max - @min
    end
  end
end

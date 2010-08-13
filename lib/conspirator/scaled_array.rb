module Conspirator
  # Scales an Array of data to fit within encoding limits.
  class ScaledArray
    # Wraps an array and scales the values between 0 and the maximum
    #
    # If the data array is changed after using this encoder, the
    # behaviour is undefined.
    #
    def initialize(data, max)
      @data = data
      @max = max
    end

    # Returns the number data will be divided by to fit within encoding limits.
    def divisor
      @divisor ||= spread / @max.to_f
    end

    # Returns the spread of the data.
    def spread
      @spread ||= @data.max - @data.min
    end

    # Returns the amount values have to be offset so the minimum value
    # equates to zero.
    def offset
      @offset ||= 0 - @data.min
    end

    # Applies scaling to the array of data.
    def scaled_data
      @scaled_data ||= @data.map {|x| ((x + offset) / divisor).round }
    end

    # Delegates Array methods to the scaled data.
    def method_missing(*args, &block)
      scaled_data.send(*args, &block)
    end
  end
end

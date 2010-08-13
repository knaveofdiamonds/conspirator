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
      @divisor ||= (spread <= @max) ? 1 : spread / @max.to_f
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

  # The Google Extended Encoding.
  #
  # Can represent integers between 0 and 4095.
  #
  # Details: http://code.google.com/apis/chart/docs/data_formats.html#extended
  class ExtendedEncoding
    # The maximum value that can be represented in this format.
    MAX = 4095

    ALL_CHARS = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a + ['-','.']
    EXT_CHARS = ALL_CHARS.map {|char_1| ALL_CHARS.map { |char_2| char_1 + char_2 } }.flatten

    # Translates a number to the extended format 2 character
    # representation.
    def translate(i)
      (i.nil? || i < 0) ? "__" : EXT_CHARS[i] || "__"
    end

    # Returns a string representation of the given scaled data in the
    # extended number format. This does not include the URL parameter
    # name.
    def encode(data)
      "e:" + ScaledArray.new(data, MAX).map {|x| translate(x) }.join('')
    end
  end
end

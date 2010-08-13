module Conspirator
  # Scales an Array of data to fit within encoding limits and formats
  # the data.
  #
  class DataEncoder
    # Creates an encoder for an array of data.
    #
    # If the data array is changed after using this encoder, the
    # behaviour is undefined.
    #
    # Uses the Extended encoding by default.
    def initialize(data, encoding=ExtendedEncoding.new)
      @data = data
      @encoding = encoding
    end

    # Returns the number data will be divided by to fit within encoding limits.
    def divisor
      @divisor ||= (spread <= @encoding.max) ? 1 : spread / @encoding.max.to_f
    end

    # Returns the spread of the data.
    def spread
      @spread ||= @data.max - @data.min
    end

    # Returns the amount values have to be shifted so the minimum value
    # equates to zero.
    def shift
      @shift ||= 0 - @data.min
    end

    # Applies scaling to the array of data.
    def scaled_data
      @scaled_data ||= @data.map {|x| ((x + shift) / divisor).round }
    end

    # Returns the encoded string for the data.
    def encode
      @encoding.apply(scaled_data)
    end

    alias :to_s :encode
  end

  # The Google Extended Encoding.
  #
  # Can represent integers between 0 and 4095.
  #
  # Details: http://code.google.com/apis/chart/docs/data_formats.html#extended
  class ExtendedEncoding
    ALL_CHARS = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a + ['-','.']
    EXT_CHARS = ALL_CHARS.map {|char_1| ALL_CHARS.map { |char_2| char_1 + char_2 } }.flatten

    # Translates a number to the extended format 2 character
    # representation.
    def translate(i)
      (i.nil? || i < 0) ? "__" : EXT_CHARS[i] || "__"
    end

    # Returns the maximum value that can be represented in this format.
    def max
      4095
    end

    # Returns a string representation of the given scaled data in the
    # extended number format. This does not include the URL parameter
    # name.
    def apply(data)
      "e:" + data.map {|x| translate(x) }.join('')
    end
  end
end

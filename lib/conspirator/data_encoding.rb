module Conspirator
  # The Google Extended Encoding.
  #
  # Can represent integers between 0 and 4095. Extended encoding gives
  # the best tradeoff between representing data faithfully and size of
  # the data parameter in the url.
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
    #
    # Takes an optional :max and/or :min value if you don't want the
    # data to be scaled to fill the graph. Out of bounds values in the
    # data given manual minimums or maximums will not be displayed.
    def encode(data, opts={})
      "e:" + ScaledArray.new(data, MAX).scale(opts).map {|x| translate(x) }.join('')
    end
  end
end

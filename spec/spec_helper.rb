$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'conspirator'
require 'spec'
require 'spec/autorun'

include Conspirator

Spec::Runner.configure do |config|
  
end

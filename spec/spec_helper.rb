$LOAD_PATH << '../lib'

require 'rspec_command'

RSpec.configure do |config|
  config.include RSpecCommand
end

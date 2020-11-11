# rspec-mocks config goes here. You can use an alternate test double
# library (such as bogus or mocha) by changing the `mock_with` option here.
RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end
end

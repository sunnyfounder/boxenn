# Based on https://github.com/dry-rb/dry-validation/blob/master/spec/spec_helper.rb

begin
  require 'byebug'
rescue LoadError
end

# require "i18n"
# require "dry/validation"

SPEC_ROOT = Pathname(__dir__)
Dir[SPEC_ROOT.join("support/**/*.rb")].each(&method(:require))

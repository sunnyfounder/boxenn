# Based on https://github.com/dry-rb/dry-validation/blob/master/spec/spec_helper.rb

SPEC_ROOT = Pathname(__dir__)
Dir[SPEC_ROOT.join('support/**/*.rb')].each(&method(:require))

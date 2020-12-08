lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boxenn/version'

Gem::Specification.new do |spec|
  spec.name        = 'boxenn'
  spec.version     = Boxenn::VERSION.dup
  spec.summary     = 'A ddd-oriented infrastructure for ruby/rails projects based on the dry-rb ecosystem.'
  spec.authors     = ['Michael Fu', 'Oscar', 'Joseph']
  spec.files       = Dir["CHANGELOG.md", "LICENSE", "README.md", "dry-validation.gemspec", "lib/**/*", "config/*.yml"]
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'dry-initializer', '~> 3.0'
  spec.add_runtime_dependency 'dry-monads', '~> 1.3'
  spec.add_runtime_dependency 'wisper', '2.0.0'
end

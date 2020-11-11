lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'homebrew/version'

Gem::Specification.new do |spec|
  spec.name        = 'homebrew'
  spec.version     = Homebrew::VERSION.dup
  spec.summary     = 'A ddd-oriented infrastructure for ruby/rails projects based on the dry-rb ecosystem.'
  spec.authors     = ['Michael Fu', 'Oscar', 'Joseph']
  spec.files       = Dir["CHANGELOG.md", "LICENSE", "README.md", "dry-validation.gemspec", "lib/**/*", "config/*.yml"]
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'dry-initializer', '~> 3.0'
end

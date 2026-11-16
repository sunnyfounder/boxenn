lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boxenn/version'

Gem::Specification.new do |spec|
  spec.name        = 'boxenn'
  spec.version     = Boxenn::VERSION.dup
  spec.license     = 'MIT'
  spec.summary     = 'A ddd-oriented infrastructure for ruby/rails projects based on the dry-rb ecosystem.'
  spec.authors     = ['Michael Fu', 'Oscar', 'Joseph']
  spec.email       = ['oscarada87@gmail.com']
  spec.files       = Dir['CHANGELOG.md', 'LICENSE', 'README.md', 'boxenn.gemspec', 'lib/**/*']
  spec.homepage    = 'https://github.com/sunnyfounder/boxenn'
  spec.required_ruby_version = '>= 3.2'
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-initializer', '~> 3.0'
  spec.add_dependency 'dry-monads', '~> 1.3'
  spec.add_dependency 'dry-struct', '>= 1.3', '< 2'
  spec.add_development_dependency 'activejob', '>= 7.1'
  spec.add_dependency 'wisper', '>= 2.0', '< 4'
  spec.metadata['rubygems_mfa_required'] = 'true'
end

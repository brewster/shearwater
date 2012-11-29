require File.expand_path('../lib/shearwater/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'shearwater'
  s.version = Shearwater::VERSION
  s.authors = ['Mat Brown']
  s.email = 'mat.a.brown@gmail.com'
  s.license = 'MIT'
  s.summary = 'Tiny everything-agnostic migrations framework'
  s.description = <<DESC
Shearwater is a tiny framework for managing migrations in an everything-agnostic
way. It provides a pluggable backend architecture for storing which migrations
have been run, and doesn't make any assumptions about what you want to do with
your migrations. Shearwater doesn't depend on any ORMs or frameworks.
DESC

  s.files = Dir['lib/**/*.rb', 'spec/**/*.rb']
  s.test_files = Dir['spec/examples/**/*.rb']
  s.has_rdoc = false
  #s.extra_rdoc_files = 'README.md'
  s.required_ruby_version = '>= 1.9'
  s.add_development_dependency 'rspec', '~> 2.0'
  s.add_development_dependency 'debugger'
  s.add_development_dependency 'yard', '~> 0.6'
end

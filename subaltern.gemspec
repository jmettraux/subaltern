
Gem::Specification.new do |s|

  s.name = 'subaltern'

  s.version = File.read(
    File.expand_path('../lib/subaltern/version.rb', __FILE__)
  ).match(/ VERSION *= *['"]([^'"]+)/)[1]

  s.platform = Gem::Platform::RUBY
  s.authors = [ 'John Mettraux' ]
  s.email = [ 'jmettraux@gmail.com' ]
  s.homepage = 'http://lambda.io'
  s.rubyforge_project = 'ruote'
  s.summary = 'an interpreter of a subset of Ruby, written in Ruby'
  s.description = %{
an interpreter of a subset of Ruby, written in Ruby
  }

  #s.files = `git ls-files`.split("\n")
  s.files = Dir[
    'Rakefile',
    'lib/**/*.rb', 'spec/**/*.rb', 'test/**/*.rb',
    '*.gemspec', '*.txt', '*.rdoc', '*.md', '*.mdown'
  ]

  #s.add_runtime_dependency 'ruby_parser', '~> 3.0'
  s.add_runtime_dependency 'parser', '1.4.1'
  #s.add_runtime_dependency 'parser', '2.0.0.beta3'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'

  s.require_path = 'lib'
end


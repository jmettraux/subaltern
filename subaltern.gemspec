# encoding: utf-8

require File.join(File.dirname(__FILE__), 'lib/subaltern/version')
  # bundler wants absolute path


Gem::Specification.new do |s|

  s.name = 'subaltern'
  s.version = Subaltern::VERSION
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

  s.add_runtime_dependency 'ruby_parser', '>= 2.0.6'

  s.add_development_dependency 'rspec'

  s.require_path = 'lib'
end


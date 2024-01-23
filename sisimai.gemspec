# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sisimai_legacy_legacy/version'

Gem::Specification.new do |spec|
  spec.name    = 'sisimai_legacy'
  spec.version = SisimaiLegacy::VERSION
  spec.authors = ['azumakuniyuki']
  spec.email   = ['azumakuniyuki+rubygems.org@gmail.com']

  spec.summary       = 'Mail Analyzing Interface'
  spec.description   = 'Sisimai is a Ruby library for analyzing RFC5322 bounce emails and generating structured data from parsed results.'
  spec.homepage      = 'https://libsisimai.org/'
  spec.license       = 'BSD-2-Clause'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 0'
  spec.add_runtime_dependency 'oj', '>= 3.0.0'
end

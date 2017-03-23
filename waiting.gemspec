# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'waiting/version'

Gem::Specification.new do |spec|
  spec.name          = 'waiting'
  spec.version       = Waiting::VERSION
  spec.authors       = ['Henry Muru Paenga']
  spec.email         = ['meringu@gmail.com']
  spec.license       = 'APACHE 2.0'

  spec.summary       = "Waits so you don't have to!"
  spec.description   = "Waits so you don't have to!"
  spec.homepage      = 'https://github.com/meringu/waiting'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.13.0'
  spec.add_development_dependency 'yard', '~> 0.9.8'
end

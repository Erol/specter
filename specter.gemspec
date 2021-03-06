# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'specter/version'

Gem::Specification.new do |spec|
  spec.name          = 'specter'
  spec.version       = Specter::VERSION
  spec.authors       = ['Erol Fornoles']
  spec.email         = ['erol.fornoles@gmail.com']
  spec.summary       = %q{Isolated specs in Ruby}
  spec.description   = %q{Isolated specs in Ruby}
  spec.homepage      = 'https://github.com/Erol/specter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'clap', '~> 1.0'

  spec.add_development_dependency 'rake', '~> 10'
end

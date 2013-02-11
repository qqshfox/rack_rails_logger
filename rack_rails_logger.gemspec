# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack_rails_logger/version'

Gem::Specification.new do |gem|
  gem.name          = "rack_rails_logger"
  gem.version       = RackRailsLogger::VERSION
  gem.authors       = ["Hanfei Shen"]
  gem.email         = ["qqshfox@gmail.com"]
  gem.description   = %q{Rails-like logger for rack}
  gem.summary       = %q{Rails-like logger for rack}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'activesupport'
  gem.add_runtime_dependency 'actionpack'
end

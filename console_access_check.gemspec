# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "console_access_check/version"

Gem::Specification.new do |gem|
  gem.authors       = ["Sofia Tzima"]
  gem.email         = ["tzi.sof@gmail.com"]
  gem.homepage      = "https://github.com/siwS/rails-console-access-check"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test}/*`.split("\n")
  gem.name          = "console_access_check"
  gem.require_paths = ["lib"]
  gem.version       = ::ConsoleAccessCheck::VERSION
  gem.license       = "MIT"

  gem.add_runtime_dependency "actionpack", ">= 2.3"
  gem.add_runtime_dependency "activerecord", ">= 2.3"

  gem.summary = gem.description = "Check who accesses your sensitive DB models"
end

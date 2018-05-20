# frozen_string_literal: true

Gem::Specification.new do |gem|
  gem.authors       = ["Sofia Tzima"]
  gem.email         = ["tzi.sof@gmail.com"]
  gem.homepage      = "https://github.com/siwS/rails-console-access-check"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test}/*`.split("\n")
  gem.name          = "console_access_check"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.1"
  gem.license       = "MIT"

  gem.add_runtime_dependency "actionpack", ">= 2.3"
  gem.add_runtime_dependency "activerecord", ">= 2.3"

  gem.summary = gem.description = "Check who accesses your sensitive DB models"
end

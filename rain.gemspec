$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rain/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rain"
  s.version     = Rain::VERSION
  s.authors     = ["Tom Scott", "Rob Di Marco"]
  s.email       = ["tom.scott@elocal.com"]
  s.homepage    = "http://github.com/eLocal/rain"
  s.summary     = "Rain is a single-command deployment engine for Rails applications."
  s.description = <<-TEXT
  Rain is a single-command deployment engine for Rails applications. It defines a set of conventions for
  deploying the same app version to multiple servers in multiple environments. Leveraging Git tags, it
  automatically increments versions according to the Semantic Versioning standard and deploys those versions
  using Capistrano to as many servers and environments as you wish."
  TEXT

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE.md", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_runtime_dependency "rails", "~> 3.2.8"
  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "capistrano"

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'guard-minitest'
  s.add_development_dependency 'guard-bundler'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'mini_specunit'
  s.add_development_dependency 'mini_shoulda'
  s.add_development_dependency 'jquery-rails'

  s.signing_key = "/Users/tom/.gem/auth/private_key.pem"
  s.cert_chain = ['gem-public-cert.pem']
end

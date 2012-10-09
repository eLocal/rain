$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rain/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rain"
  s.version     = Rain::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Rain."
  s.description = "TODO: Description of Rain."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "thor"
  s.add_dependency "capistrano"
end

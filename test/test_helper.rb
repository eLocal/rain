# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

require 'bundler'
Bundler.require :default, :development

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

class ActiveSupport::TestCase
  setup do
    %x(mkdir -p config)
    File.open File.expand_path('./config/versions.yml'), 'w' do |f|
      f.puts <<YAML
---
stage: rel_0.0.1
production: rel_0.0.1
YAML
    end
  end

  teardown do
    %(rm -rf config/)
  end
end

require 'bundler'
Bundler.require :default

require 'rain/semantic_version'
require 'rain/config'
require 'rain/git_tools'
require 'rain/deployer'
require 'rails/all'

require 'pathname'
ENV['BUNDLE_GEMFILE'] ||= File.expand_path("../../Gemfile", Pathname.new(__FILE__).realpath)

module Rain
  def self.version
    config = Rain::Config.new(Dir.pwd)
    config.versions
  end
end

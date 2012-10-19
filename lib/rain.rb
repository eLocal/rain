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
    root_path = if ENV['RAILS_ENV'] == 'test'
                  File.expand_path './'
                else
                  Rails.root
                end
    config = Rain::Config.new root_path
    config.versions
  end
end

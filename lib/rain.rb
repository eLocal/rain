require 'bundler'
Bundler.require :default

require 'rain/git_tools'
require 'rain/deployer'
require 'rails/all'

#require 'pathname'
#ENV['BUNDLE_GEMFILE'] ||= File.expand_path("../../Gemfile", Pathname.new(__FILE__).realpath)

module Rain
  def self.versions
    "#{Rails.root}/config/versions.yml"
  end
end

require 'active_support/all'

module Rain
  # Holds the configuration options for Rain from versions.yml in a
  # HashWithIndifferentAccess.
  class Config
    attr_reader :yaml_file

    def initialize(root)
      @versions_yml = YAML::load_file "#{root}/config/versions.yml"
      @tracker_yml = YAML::load_file "#{root}/config/tracker.yml"
    end

    def versions
      @versions ||= if @versions_yml.present?
                      ActiveSupport::HashWithIndifferentAccess.new @versions_yml
                    else
                      false
                    end
    end

    def tracker
      @tracker ||= if @tracker_yml.present?
                      ActiveSupport::HashWithIndifferentAccess.new @tracker_yml
                   else
                     false
                   end
    end
  end
end

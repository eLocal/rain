module Rain
  # Holds the configuration options for Rain from versions.yml in a
  # HashWithIndifferentAccess.
  class Config
    attr_reader :yaml_file

    def initialize
      @yaml_file = YAML::load_file "#{Rails.root}/config/versions.yml"
    end

    def versions
      @versions ||= if @yaml_file.present?
                      ActiveSupport::HashWithIndifferentAccess.new @yaml_file
                    else
                      false
                    end
    end
  end
end

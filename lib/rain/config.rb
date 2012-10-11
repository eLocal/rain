module Rain
  class Config
    include ActiveSupport::HashWithIndifferentAccess

    def initialize
    end

    def versions
      @versions ||= HashWithIndifferentAccess.new yaml_file
    end

  private
    def yaml_file
      YAML::load_file "#{Rails.root}/config/versions.yml"
    end
  end
end

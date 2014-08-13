module Rain
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def copy_config_file
      copy_file "versions.yml", "config/versions.yml"
    end

    def show_capistrano_instructions
      say <<-TEXT

      Please add `require 'rain/capistrano'` to Capfile and
      define your stages in config/deploy

      Then, all you have to do to deploy to all of your servers is

          rain on {environment}

      Consult http://github.com/eLocal/rain/wiki for more information.

      TEXT
    end
  end
end

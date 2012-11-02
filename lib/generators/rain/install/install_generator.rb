module Rain
  class InstallGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def copy_config_file
      copy_file "config/versions.yml", "#{Rails.root}/config/versions.yml"
    end

    def show_capistrano_instructions
      say <<-TEXT
        Please add `require 'rain/capistrano'` to config/deploy.rb and
        define your :to_stage and :to_production tasks in your Capistrano
        recipe. Then, all you have to do to deploy to all of your servers
        is `rain on {environment}`.
      TEXT
    end
  end
end

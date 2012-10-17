require 'thor'

module Rain
  class Deployer < Thor
    include Thor::Actions
    include GitTools

    desc "on ENVIRONMENT", "Tag current HEAD and push it to the chosen environment. (default: 'production')"

    method_option :force, type: :boolean, desc: "Force a release, do not prompt", aliases: "-f"
    method_option :"keep-current-version", type: :boolean, desc: "Reuse the previous tag", aliases: "-k"
    method_option :patch, default: true,  desc: SemanticVersion::PATCH
    method_option :minor, default: false, desc: SemanticVersion::MINOR
    method_option :major, default: false, desc: SemanticVersion::MAJOR
    method_option :smoke, default: false, desc: "Run tests after deployment"

    def on environment="production"

      say "Makin it raaaaaain on #{environment}..."

      return unless working_directory_copasetic?

      unless options[:"keep-current-version"] or environment == 'production'
        update_release_tag(environment, tag.to_s)
        run_cmd("git tag #{tag.to_s}")
        push_tag(tag)
      end

      run_cmd "bundle exec cap to_#{environment} deploy"

      say "It's a celebration, bitches!"
    end

    default_task :on

  private
    no_tasks do
      def run_smoke_tests
        #run Rain.config.smoke_test_command
      end

      def tag
        @tag ||= case true
          when options[:minor] then increment_minor_version
          when options[:major] then increment_major_version
        else
          say "No version type detected, assuming you meant '--patch' (as it is default)"
          increment_patch_version
        end
      end
    end
  end
end

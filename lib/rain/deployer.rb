require 'thor'

module Rain
  class Deployer < Thor
    include Thor::Actions
    include GitTools

    desc "on ENVIRONMENT", "Tag current HEAD and push it to the chosen environment. (default: 'production')"

    method_option :force, type: :boolean, desc: "Force a release, do not prompt", aliases: "-f"
    method_option :"keep-current-version", type: :boolean, desc: "Reuse the previous tag", aliases: "-k"
    method_option :patch, default: true,  desc: SemanticVersion::PATCH, type: :boolean
    method_option :minor, default: false, desc: SemanticVersion::MINOR, type: :boolean
    method_option :major, default: false, desc: SemanticVersion::MAJOR, type: :boolean
    def on environment="production"
      say "Making it rain on #{environment}..."

      return unless working_directory_copasetic?(options)

      unless options[:"keep-current-version"] || environment == 'production'
        update_release_tag(environment, tag.to_s)
        run_cmd("git tag #{tag.to_s}")
        push_tag(tag)
      else
        update_release_tag(environment, GitTools::ReleaseTag.current("staging"))
        say "Deploying existing tag #{GitTools::ReleaseTag.current("staging")} to '#{environment}'."
      end

      run "bundle exec cap #{environment} deploy"

      say "Got a handful of stacks better grab an umbrella."
    end

    default_task :on

  private
    no_tasks do
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

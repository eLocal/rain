module Rain
  class Deployer < Thor
    include Thor::Actions
    include GitTools

    desc :to_stage, "Tag current branch and push it to stage"
    method_option :force, :type => :boolean,
      :desc => "Force a release to occur without any prompting", :aliases => "-f"
    method_option :"keep-current-version", :type => :boolean,
      :desc => "Do not create a new tag, just reuse the previous tag", :aliases => "-k"
    method_option :patch, default: true,  desc: "Patch versions are incremented if only backwards compatible bug fixes are introduced. A bug fix is defined as an internal change that fixes incorrect behavior."
    method_option :minor, default: false, desc: "Minor versions are incremented if new, backwards compatible functionality is introduced to the public API, or if older functionality is deprecated."
    method_option :major, default: false, desc: "Major versions are incremented if any backwards incompatible changes are introduced to the public API. It MAY include minor and patch level changes."
    def on(environment="production")
      say "Makin it raaaaaain on #{environment}..."
      return unless working_directory_copasetic?
      unless options[:"keep-current-version"]
        update_release_tag(environment, tag.to_s)
        run_cmd("git tag #{tag.to_s}")
        push_tag(tag)
      end
      run_cmd "bundle exec cap to_#{environment} deploy"
      run_smoke_tests_for 'stage'
      say "It's a celebration, bitches!"
    end

  private
    no_tasks do
      def run_smoke_tests_for environment
        ENV['REMOTE_ENV'] = environment
        ENV['SMOKE'] = 'true'
        `bundle exec rspec spec/requests`
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

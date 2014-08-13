# = Capistrano tasks
#
# A simple addon to Capistrano that defines some callbacks
# and deploy tasks.
#
# The to_latest_tag task abstracts setting the branch of each
# deployment to the current ReleaseTag.

require 'capistrano'

require 'rain/git_tools'

module Rain
  Capistrano::Configuration.instance(:must_exist).load do
    after "staging", "to_latest_tag"
    after "production", "to_latest_tag"

    task :to_latest_tag do
      set :branch, GitTools::ReleaseTag.current(rails_env)
    end
  end
end

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
    include GitTools

    after "to_stage",       "to_latest_tag"
    after "to_production",  "to_latest_tag"

    task :to_latest_tag do
      if rails_env == 'stage'
        set :branch, ReleaseTag.current(rails_env)
      else
        set :branch, ReleaseTag.latest
      end
    end
  end
end

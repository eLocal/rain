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

    after "deploy:update",  "deploy:email"

    namespace :deploy do
      desc "Send deployment notification email to the development team, set by the `:developers` setting in your config/deploy.rb."
      task :email, :role => :app do
        class GitTool
          include GitTools
        end

        versions = YAML.load_file(Pathname(__FILE__).dirname.expand_path.join('versions.yml'))

        body = if !versions.nil? and versions[rails_env]
          git_tags = %x(git tag).split("\n").
            select { |l| l =~ /^rel_/ }.
            map { |l| ReleaseTag.new(l) }.sort
          current_release = versions[rails_env]
          previous_release = git_tags[-2]
          change_log = %x(git log --pretty=format:'%cn (%cr): %s%n%mhttps://github.com/eLocal/elocal_web/commit/%H %n' --date=relative #{previous_release}..#{current_release})

          "<img src=\"http://assets.elocal.com/deploy/dane.jpg\">
<p>#{deployer} has updated the #{rails_env.downcase} API to #{versions[rails_env]}.</p>
<p>
Change log: https://github.com/eLocal/affiliates/compare/#{previous_release}...#{current_release}
</p>
<pre>
#{change_log}
</pre>
<p>
  Love,<br>
  #{deployer}
</p>"
        else
          "API Environment #{rails_env} has been updated to master."
        end

        subject = "API #{rails_env} environment bumped to #{versions[rails_env]}"

        %x(echo 'To: #{developers}\nSubject: #{subject}\nContent-Type: text/html;charset="us-ascii"\n\n<html>#{body}</html>' | sendmail -t) rescue puts "Console mail could not send message"
      end
    end
  end
end

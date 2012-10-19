require 'pivotal-tracker'

module Rain
  module BugTracker
    def self.deliver_all_finished_stories!
      project.stories.all(status: "Finished").each do |story|
        story.status = "Delivered"
        story.save
      end

      true
    end

  private
    def tracker
      @tracker ||= begin
        username = Rain::Config.tracker[:username]
        password = Rain::Config.tracker[:password]

        PivotalTracker::Client.new(username, password)
      end
    end

    def project
      @project ||= tracker.projects.find Rain::Config.tracker[:project_id]
    end
  end
end

require 'pivotal-tracker'

module Rain
  class BugTracker
    def initialize
      username = Rain::Config.tracker[:username]
      password = Rain::Config.tracker[:password]
      @tracker = PivotalTracker::Client.new(username, password)
      @project = @tracker.project.find Rain::Config.tracker[:project_id]
    end

    def deliver_all_finished_stories!
      @project.stories.all(status: "Finished").each do |story|
        story.status = "Delivered"
        story.save
      end
    end
  end
end

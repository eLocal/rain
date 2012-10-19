require 'test_helper'

class Rain::BugTrackerTest < ActiveSupport::TestCase
  setup { @tracker = Rain::BugTracker.new }

  test "deliver all finished stories" do
    assert @tracker.deliver_all_finished_stories!
  end
end

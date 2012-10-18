require 'test_helper'

class GitTools::ReleaseTagTest < ActiveSupport::TestCase
  include GitTools

  describe "ReleaseTag: Comparison" do
    should "compare numerically with the other tag" do
      pre_release = ReleaseTag.new("rel_0.5.0.0")
      final_release = ReleaseTag.new("rel_1.0.0.0")

      refute_equal pre_release, final_release

      pre_release.major = 1
      pre_release.minor = 0
      pre_release.patch = 0
      pre_release.other = 0

      assert_equal pre_release, final_release
    end
  end
end

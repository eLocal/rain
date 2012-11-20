require 'test_helper'
require 'rain/git_tools'

class Rain::GitToolsTest < ActiveSupport::TestCase
  include GitTools

  describe "GitTools: working_directory_copasetic?" do
    should "return true when forced" do
      assert working_directory_copasetic?(force: true)
    end
  end

  describe "GitTools: on_master?" do
    should "return true when we are on the master branch" do
      assert %x(git checkout master > /dev/null), "master not checked out"
      assert on_master?
    end

    should "return false when we are on any other branch" do
      original_branch = %x(git branch | grep '*').gsub! /\*\s|\n/, ""
      assert_equal 'master', original_branch
      assert %x(git checkout -b some-branch > /dev/null), "some-branch not checked out"
      refute on_master?

      assert %x(git checkout #{original_branch} > /dev/null), "master not checked out"
      assert %x(git branch -d some-branch > /dev/null), "some-branch was not deleted"
    end
  end

  describe "GitTools: no_changes_pending?" do
    should "return false when there are uncommitted changes" do
      assert %x(echo "test" >> LICENSE.md), "LICENSE.md was not edited"
      refute no_changes_pending?, "LICENSE.md is still clean"
      assert %x(git checkout HEAD LICENSE.md), "LICENSE.md not reset to HEAD state"
      assert no_changes_pending?, "LICENSE.md is still dirty. Make sure you commit everything else!"
    end
  end

  describe "GitTools: last_release_tag" do
    setup { %x(git tag rel_9.9.999) }

    should "return the last release_tag entered into git" do
      assert_equal ReleaseTag.latest, last_release_tag
    end

    teardown { %x(git tag -d rel_9.9.999) }
  end

  describe "GitTools: git_name" do
    setup { @original_name = %x(git config user.name); %x(git config user.name "OJ Simpson") }

    should "return the name set in ~/.gitconfig" do
      assert_equal "OJ Simpson", git_name
    end

    teardown { %x(git config user.name "#{@original_name}") }
  end

  describe "GitTools: tagged_latest_version?" do
    setup { %x(git tag rel_0.0.1) }

    should "return true when the current tag and the latest-released tag are the same" do
      refute_nil ReleaseTag.current
      refute_nil ReleaseTag.latest
      assert tagged_latest_version?, "Latest version not tagged"
    end

    should "return false when the current tag has not been pushed" do
      assert %x(git tag rel_0.0.2), "Couldn't create latest tag"
      refute tagged_latest_version?, "Latest version tagged"
      assert %x(git tag -d rel_0.0.2), "Couldn't delete tag"
    end
    
    teardown { %x(git tag -d rel_0.0.1) }
  end

  #describe "GitTools: push_tag" do
    #should "push the tag to origin/master"
    #should "log an error if tag is nil"
  #end

  #describe "GitTools: run_cmd" do
    #should "execute the given shell command"
  #end

  #describe "GitTools: versions_path" do
    #should "return the full path to the versions.yml file"
  #end

  #describe "GitTools: versions_hash" do
    #should "return a YAML Hash of the versions.yml file"
  #end

  #describe "GitTools: update_release_tag" do
    #should "write the versions_hash to versions.yml"
    #should "commit and push that change to origin/master"
  #end
end

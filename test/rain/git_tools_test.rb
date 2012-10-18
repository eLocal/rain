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
      assert %x(git checkout master), "master not checked out"
      assert on_master?
    end

    should "return false when we are on any other branch" do
      original_branch = %x(git branch | grep '*').gsub! /\*\s|\n/, ""
      assert_equal 'master', original_branch
      assert %x(git checkout -b some-branch), "some-branch not checked out"
      refute on_master?

      assert %x(git checkout #{original_branch}), "master not checked out"
      assert %x(git branch -d some-branch), "some-branch was not deleted"
    end
  end

  describe "GitTools: no_changes_pending?" do
    should "return false when there are uncommitted changes" do
      assert %x(echo "test" >> LICENSE.md), "LICENSE.md was not edited"
      refute no_changes_pending?, "LICENSE.md is still clean"
    end

    should "return true when the directory is clean" do
      assert %x(git checkout HEAD LICENSE.md), "LICENSE.md not reset to HEAD state"
      assert no_changes_pending?, "LICENSE.md is still dirty. Make sure you commit everything else!"
    end
  end

  describe "GitTools: last_release_tag" do
    should "return the last release_tag entered into git" do
      assert %x(git tag rel_9.9.999)
      assert_equal ReleaseTag.latest, last_release_tag
      assert %x(git tag -d rel_9.9.999)
    end
  end

  #describe "GitTools: git_name" do
    #should "return the name set in ~/.gitconfig" do

    #end
  #end

  #describe "GitTools: tagged_latest_version?" do
    #should "return true when the current tag and the latest-released tag are the same"
    #should "return false when the current tag has not been pushed"
  #end

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

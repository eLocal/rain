require 'test_helper'

class Rain::GitToolsTest < ActiveSupport::TestCase
  describe "GitTools: working_directory_copasetic?" do
    should "prompt the user when there are uncommitted changes"
    should "return true when forced"
    should "return true when the repo directory is clean"
  end

  describe "GitTools: on_master?" do
    should "return true when we are on the master branch"
    should "return false when we are on any other branch"
  end

  describe "GitTools: no_changes_pending?" do
    should "return true when there are uncommitted changes"
    should "return false when the directory is clean"
  end

  describe "GitTools: last_release_tag" do
    should "return the last release_tag entered into git"
  end

  describe "GitTools: git_name" do
    should "return the name set in ~/.gitconfig"
  end

  describe "GitTools: tagged_latest_version?" do
    should "return true when the current tag and the latest-released tag are the same"
    should "return false when the current tag has not been pushed"
  end

  describe "GitTools: push_tag" do
    should "push the tag to origin/master"
    should "log an error if tag is nil"
  end

  describe "GitTools: run_cmd" do
    should "execute the given shell command"
  end

  describe "GitTools: versions_path" do
    should "return the full path to the versions.yml file"
  end

  describe "GitTools: versions_hash" do
    should "return a YAML Hash of the versions.yml file"
  end

  describe "GitTools: update_release_tag" do
    should "write the versions_hash to versions.yml"
    should "commit and push that change to origin/master"
  end
end

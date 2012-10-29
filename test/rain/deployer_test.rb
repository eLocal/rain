require 'test_helper'

class Rain::DeployerTest < ActiveSupport::TestCase
  describe "DeployerTest: bare invocation" do
    setup { @command = %x(./bin/rain) }

    should "deploy a new tag to stage" do
      skip "suck it"
      assert_match 'Got a handful of stacks better grab an umbrella', @command
    end

    should "deploy the same tag that's on stage to production" do
      assert_match 'jflksjflksjfl;', @command
    end
  end

  describe "DeployerTest: help invocation for 'on'" do
    before { @command = %x(./bin/rain help on) }

    should "prompt for an environment" do
      assert_match 'rain on ENVIRONMENT', @command
    end

    should "be incrementable by patch version" do
      assert_match '--patch', @command
    end

    should "be incrementable by minor version" do
      assert_match '--minor', @command
    end

    should "be incrementable by major version" do
      assert_match '--major', @command
    end
  end
end

require 'test_helper'

class Rain::DeployerTest < ActiveSupport::TestCase
  describe "DeployerTest: bare invocation" do
    before { @command ||= %x(./bin/rain) }

    should "deploy to production" do
      assert_match 'Got a handful of stacks better grab an umbrella', @command
    end
  end

  describe "DeployerTest: specific environment invocation" do
    context "on stage" do
      before { @command ||= %x(./bin/rain on stage) }

      should "deploy a new tag to stage" do
        assert_match 'Deploying existing tag', @command
      end
    end

    context "on production" do
      before { @command ||= %x(./bin/rain on production) }

      should "deploy the same tag that's on stage to production" do
        assert_match 'Deploying existing tag', @command
      end
    end
  end

  describe "DeployerTest: help invocation for 'on'" do
    before { @command ||= %x(./bin/rain help on) }

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

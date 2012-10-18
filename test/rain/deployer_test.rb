require 'test_helper'

class Rain::DeployerTest < ActiveSupport::TestCase
  describe "DeployerTest: bare invocation" do
    before do
      %x(mkdir -p config)
      unless IO.read('test/dummy/config/versions.yml') == IO.read("#{Rails.root}/config/versions.yml")
        %x(cp test/dummy/config/versions.yml #{Rails.root}/config/versions.yml)
      end
      @command = %x(./bin/rain)
    end

    should "deploy to production" do
      assert_match /Makin it raaaaaain on production/, @command
    end

    after { %x(rm -rf config/) }
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

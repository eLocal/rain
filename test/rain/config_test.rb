require 'test_helper'

class Rain::ConfigTest < ActiveSupport::TestCase
  setup { @config = Rain::Config.new File.expand_path('./') }

  test "get YAML file" do
    refute_empty @config.yaml_file
  end

  test "creates a proper hash" do
    assert @config.versions.is_a? ActiveSupport::HashWithIndifferentAccess
  end
end

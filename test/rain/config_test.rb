require 'test_helper'

class Rain::ConfigTest < ActiveSupport::TestCase
  setup do
    %x(mkdir -p config)
    file = File.open File.expand_path('./config/versions.yml'), 'w' do |f|
      f.puts <<YAML
---
stage: rel_0.0.1
production: rel_0.0.1
YAML
    end

    @config = Rain::Config.new File.expand_path('./')
  end

  test "get YAML file" do
    refute_empty @config.yaml_file
  end

  test "creates a proper hash" do
    assert @config.versions.is_a? ActiveSupport::HashWithIndifferentAccess
  end

  teardown do 
    %x(rm -rf config/)
  end
end

require 'spec_helper'
describe(Rain::Config) do
  let(:config) { Rain::Config.new File.dirname(__FILE__) }

  it 'can get a yaml file' do
    expect(config.yaml_file).not_to be_empty
  end

  it 'is a indifferent hash' do
    expect(config.versions).to be_a(ActiveSupport::HashWithIndifferentAccess)
  end
end

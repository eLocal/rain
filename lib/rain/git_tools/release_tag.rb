module GitTools
  # Represents an API release, which is tagged in the repository as
  # +rel_<MAJOR>.<MINOR>.<PATCH>+. Capistrano uses this pushed tag
  # to deploy the next version of the API, which is reflected in the
  # footer of each page. In development mode, this simply returns the
  # latest commit in master.
  class ReleaseTag
    attr_accessor :major, :minor, :patch, :other

    # Create a new ReleaseTag from a version string.
    def initialize(tag=nil)
      @major, @minor, @patch, @other = tag.gsub(/^rel_/,'').split(/[^0-9a-zA-Z]+/).map(&:to_i) unless tag.nil?
    end

    # Version number as an array of integers.
    def to_a
      [@major, @minor, @patch, @other].compact
    end

    # Compare two tags by version. The latest version is always chosen.
    def <=>(rel_tag)
      to_a <=> rel_tag.to_a
    end

    # Version number as a string, or tag name.
    def to_s
      "rel_" + to_a.compact.join(".")
    end

    # Return the current ReleaseTag as specified in versions.yml.
    def self.current environment="production"
      version = YAML.load_file(File.expand_path("../../../config/versions.yml", __FILE__))[environment]
      ReleaseTag.new(version)
    end

    # Return the latest ReleaseTag as computed by looking at the most
    # recent "rel_*" tag created on Git.
    def self.latest
      tags = %x(git tag).split("\n").select{|l| l =~ /^rel_/}.map{ |l| ReleaseTag.new(l) }.sort
      tags.last
    end
  end
end

require 'thor'
require_relative 'git_tools/release_tag'

# A collection of methods and a class, +ReleaseTag+, for querying the
# local Git repository. Originally part of the Thor binary, it was
# extracted to its own module after +Rain::Deployer+ got too large.
module GitTools
  include Thor::Actions

  # A short user prompt if there are uncommitted changes in the repo, in
  # case the user forgets before they deploy. Naturally, one may cancel
  # this process effectively cancelling the entire deploy cleanly. This
  # occurs before any hard changes (e.g., writing changes, pushes,
  # command execution, etc.) are made.
  def working_directory_copasetic?
    return true if options[:force]
    return false unless no_changes_pending? || yes?("There are currently uncommitted changes.  Are you sure you want to continue? [y/N]")
    return false unless on_master? || yes?("You are not currently on the master branch.  Are you sure you want to continue? [y/N]")
    true
  end

  # Test whether we are currently using the master branch. All
  # deployment activity should take place on the master branch.
  def on_master?
    out = %x(git symbolic-ref -q HEAD)
    out.strip == "refs/heads/master"
  end

  # Test whether there are any uncommitted changes in the working
  # directory.
  def no_changes_pending?
    %x(git status --porcelain).split("\n").length == 0
  end

  # Moved code to ReleaseTag. Basically returns a ReleaseTag with a version
  # equal to the latest Git tag.
  def last_release_tag
    ReleaseTag.latest
  end

  # Display name as set in +~/.gitconfig+
  def git_name
    %x(git config --get user.name).split("\n")[0]
  end

  # Compares the latest Git tag with the latest version name in YAML. If
  # both of those are equal, this returns +true+, because the Git tags
  # are in sync with versions.yml
  def tagged_latest_version?
    ReleaseTag.latest == ReleaseTag.current
  end

  %w(major minor patch).each do |f|
    define_method :"increment_#{f}_version" do
      tag = last_release_tag
      case f
      when "major"
        tag.major += 1
        tag.minor = 0
        tag.patch = 0
        tag.other = nil
      when "minor"
        tag.minor += 1
        tag.patch = 0
        tag.other = nil
      when "patch"
        tag.patch += 1
        tag.other = nil
      end
      tag
    end
  end

  # Push a given +ReleaseTag+ to +origin+. You must have a Git
  # remote set up for this to work.
  def push_tag(tag)
    unless tag.nil?
      run_cmd "git push origin #{tag}"
    end
  end

  # Execute any shell commnad, unless we're testing. But always print
  # what is/what would have been executed onto stdout.
  def run_cmd(cmd)
    puts "executing... #{cmd}"
    %x(#{cmd}) unless ENV['RAILS_ENV'] == "test"
  end

  # Full path of the versions.yml file in the Rails app.
  def versions_path
    File.expand_path "./config/versions.yml"
  end

  # A YAML-parsed Hash of the versions.yml file.
  def versions_hash
    YAML.load_file(versions_path)
  end

  # Write the newest ReleaseTag's version number to versions.yml, save
  # it, and commit/push it to +origin/master+.
  def update_release_tag(environment, tag)
    hsh = versions_hash
    hsh[environment] = tag
    File.write(versions_path, hsh.to_yaml.to_s)
    run_cmd "git commit -m '[RELEASE][#{environment}] Update release tag for #{environment} to #{tag}' #{versions_path}"
    run_cmd "git push origin master"
  end
end

require 'git_tools/release_tag'

module GitTools
  def working_directory_copasetic?
    return true if options[:force]
    return false unless no_changes_pending? || yes?("There are currently uncommitted changes.  Are you sure you want to continue? [y/N]")
    return false unless on_master? || yes?("You are not currently on the master branch.  Are you sure you want to continue? [y/N]")
    true
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

  def push_tag(tag)
    unless tag.nil?
      run_cmd "git push origin #{tag}"
    end
  end

  def run_cmd(cmd)
    puts "executing... #{cmd}"
    %x(#{cmd})
  end

  def versions_path
    File.expand_path("../../config/versions.yml", __FILE__)
  end

  def versions_hash
    YAML.load_file(versions_path)
  end

  def update_release_tag(environment, tag)
    hsh = versions_hash
    hsh[environment] = tag
    File.write(versions_path, hsh.to_yaml)
    run_cmd "git commit -m '[RELEASE][#{environment}] Update release tag for #{environment} to #{tag}' #{versions_path}"
    run_cmd "git push"
  end
end

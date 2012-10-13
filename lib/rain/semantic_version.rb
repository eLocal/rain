# Holds the full text to semantic version information for the help task,
# because keeping them in Rain::Deployer seemed ugly.
module Rain
  module SemanticVersion
    MAJOR = <<-TEXT
    Major versions are incremented if any backwards incompatible changes are introduced to the public API. 
    It MAY include minor and patch level changes.
    TEXT

    MINOR = <<-TEXT
    Minor versions are incremented if new, backwards compatible functionality is introduced to the public  
    API, or if older functionality is deprecated.
    TEXT

    PATCH = <<-TEXT
    Patch versions are incremented if only backwards compatible bug fixes are introduced. A bug fix is 
    defined as an internal change that fixes incorrect behavior." 
    TEXT
  end
end

##############################################################################
# File::    assertable.rb
# Purpose:: Useful assertions
#
# Author::    Jeff McAffee 03/28/2015
##############################################################################


module Assertable

  # ConfigurationError Asserts
  #
  def assert_org_is_configured org
    unless PortalModule.configuration.orgs.key?(org)
      raise ConfigurationError, "Org Unit has not been configured - #{org}"
    end
  end

  def assert_dl_dir_is_configured
    dd = PortalModule.configuration.download_dir
    if (dd.nil? || dd.to_s.empty?)
      raise ConfigurationError, "Download directory has not been configured"
    end
  end

  # File System Asserts
  def assert_dir_exists path
    path = Pathname(path)
    dir = path.dirname
    raise IOError, "No such directory - #{path}" unless dir.exist?
  end

  def assert_file_exists path
    path = Pathname(path)
    raise IOError, "File not found: #{path}" unless path.exist? && !path.directory?
  end
end

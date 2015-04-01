##############################################################################
# File::    config_helper.rb
# Purpose:: Configuration object wrapper
#
# Author::    Jeff McAffee 2015-03-29
#
##############################################################################

module PortalModule
  class ConfigHelper

    def self.env=(env)
      @env = env.to_sym
    end

    def self.env
      @env ||= PortalModule.configuration.default_environment
    end

    def self.page_factory=(factory)
      @page_factory = factory
    end

    def self.page_factory
      @page_factory ||= PageFactory.new
    end

    def self.credentials
      PortalModule.configuration.credentials[env]
    end
  end
end # PortalModule

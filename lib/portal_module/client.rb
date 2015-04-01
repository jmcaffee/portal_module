##############################################################################
# File::    client.rb
# Purpose:: PortalModule client object
# 
# Author::    Jeff McAffee 2015-03-27
##############################################################################

module PortalModule
  class Client

    attr_writer :page_factory

    #
    # Override credentials
    #

    attr_writer :user
    attr_writer :password

    def env=(environment)
      PortalModule.configuration.current_env = environment
    end

    def env
      PortalModule.configuration.current_env
    end

    def loan_entry
      login
      LoanEntry.new page_factory
    end

    def dts
      login
      Dts.new page_factory
    end

    def page_factory
      @page_factory ||= PortalModule::PageFactory.new
    end

    ##
<<<<<<< HEAD
    # Login to the admin module.
=======
    # Login to the portal
>>>>>>> b947a5d3cfb546e2133836adecd77d0487b4ff77
    #
    # If no credentials are provided, try to get credentials from the config object.
    #

    def login(user = nil, pass = nil)
      if @logged_in
        return true
      end

      user, pass = verify_credentials user, pass

      logout
      page_factory.login_page(true).login_as(user, pass)
      @logged_in = true
    end

    ##
<<<<<<< HEAD
    # Logout of the admin module
=======
    # Logout of the portal
>>>>>>> b947a5d3cfb546e2133836adecd77d0487b4ff77
    #

    def logout
      page_factory.login_page(true).logout
      @logged_in = false
    end

    ##
<<<<<<< HEAD
    # Logout of the admin module and quit the browser
=======
    # Logout of the portal and quit the browser
>>>>>>> b947a5d3cfb546e2133836adecd77d0487b4ff77
    #

    def quit
      logout
      page_factory.login_page(false).browser.close
    end

  private

    ##
    # If credential args are empty, attempt to look them up,
    #  first in the client attributes, then in the config obj.

    def verify_credentials user, pass
      return [user, pass] if valid_user_and_pass? user, pass

      # Pull values stored in this client.
      user, pass = @user, @password
      return [user, pass] if valid_user_and_pass? user, pass

      # Pull values stored in the config.
      user, pass = PortalModule.configuration.user_credentials
      return [user, pass] if valid_user_and_pass? user, pass

      fail AuthenticationRequired.new("Missing credentials for #{env}")
    end

    def valid_user_and_pass? user, pass
      if user.nil? || user.empty?
        return false
      end

      if pass.nil? || pass.empty?
        return false
      end

      true
    end
  end # Client
end # PortalModule

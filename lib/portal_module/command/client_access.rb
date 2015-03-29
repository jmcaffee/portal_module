##############################################################################
# File::    client_access.rb
# Purpose:: Module providing client access helper methods for CLI classes.
# 
# Author::    Jeff McAffee 2015-03-27
##############################################################################

module PortalModule
  module Command
    module ClientAccess
      private def credentials
        config = PortalModule.configuration
        user, pass = config.user_credentials
        if user.nil? || pass.nil?
          user = ask "username for #{config.current_env} environment:"
          pass = ask "password:", echo: false
          # Force a new line - hiding the echo on the password eats the new line.
          say "\n"
        end
        [user, pass]
      end

      private def client
        return @client unless @client.nil?

        @client = PortalModule.client
        @client.env = options[:environment] unless options[:environment].nil?

        user, pass = credentials
        if user.empty? || pass.empty?
          say "missing credentials", :red
          return
        end

        @client.user = user
        @client.password = pass
        @client
      end
    end # ClientAccess
  end # Command
end # PortalModule

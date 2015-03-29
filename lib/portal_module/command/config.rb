##############################################################################
# File::    config.rb
# Purpose:: Config command
# 
# Author::    Jeff McAffee 2015-03-27
##############################################################################

module PortalModule
  module Command
    class Config < Thor

      ###
      # Add commands
      #

      class Add < Thor

        desc "env <envname> <url>", "add a environment url"
        def env(envname, url)
          with_loaded_config do
            unless PortalModule.configuration.base_urls.key? envname.to_sym
              PortalModule.configuration.base_urls[envname.to_sym] = url
            else
              say "environment '#{envname}' already exists", :red
            end
          end
        end

        desc "org <orgname> <orgid>", "add an Org Unit and ID"
        def org(orgname, orgid)
          with_loaded_config do
            unless PortalModule.configuration.orgs.key? orgname
              PortalModule.configuration.orgs[orgname] = orgid
            else
              say "org unit '#{orgname}' already exists", :red
            end
          end
        end

        desc "credentials <envname> <username> <pass>", "add login credentials for an environment"
        def credentials(envname, username, pass)
          with_loaded_config do
            if PortalModule.configuration.base_urls.key? envname.to_sym
              unless PortalModule.configuration.credentials.key? envname.to_sym
                PortalModule.configuration.credentials[envname.to_sym] = [username, pass]
              else
                say "credentials already exist for environment '#{envname}'", :red
              end
            else
              say "environment '#{envname}' doesn't exist", :red
              say "create environment before adding credentials"
            end
          end
        end

      private

        def with_loaded_config &block
          fail "expecting block" unless block_given?

          unless PortalModule.load_configuration
            say "Configuration file not found!", :red
            say "Have you tried 'config init' first?"
            return
          end

          yield

          PortalModule.save_configuration
        end
      end

      desc "add [CATEGORY]", "add a configuration value"
      subcommand "add", Add

      ###
      # Show commands
      #

      class Show < Thor

        desc "envs", "display configured environments"
        def envs
          with_loaded_config do
            say "Environments:"

            output = []
            PortalModule.configuration.base_urls.each do |env, url|
              output << [env, url]
            end
            print_table output, indent: 8
          end
        end

        desc "orgs", "display configured Org Units"
        def orgs
          with_loaded_config do
            say "Org Units:"

            output = []
            PortalModule.configuration.orgs.each do |org, id|
              output << [org, id]
            end
            print_table output, indent: 8
          end
        end

        desc "credentials <envname>", "display configured credentials for an environment"
        long_desc <<-LD
          Display configured credentials for an environment.

          If an environment name is not provided, credentials for all
          environments will be displayed.
        LD
        def credentials(envname=nil)
          with_loaded_config do
            say "credentials:"

            output = []
            PortalModule.configuration.credentials.each do |env, cred|
              if envname.nil? || env == envname.to_sym
                output << [env, cred.first, cred.last]
              end
            end
            print_table output, indent: 8
          end
        end

      private

        def with_loaded_config &block
          fail "expecting block" unless block_given?

          unless PortalModule.load_configuration
            say "Configuration file not found!", :red
            say "Have you tried 'config init' first?"
            return
          end

          yield
        end
      end

      desc "show [CATEGORY]", "display configuration values for [CATEGORY]"
      subcommand "show", Show

      ###
      # Del commands
      #

      class Del < Thor

        desc "env <envname>", "delete an environment configuration"
        def env(envname)
          with_loaded_config do
            if PortalModule.configuration.base_urls.key?(envname.to_sym)
              PortalModule.configuration.base_urls.delete(envname.to_sym)
            end
          end

          credentials(envname)
        end

        desc "org <orgname>", "delete an Org Unit"
        def org(orgname)
          with_loaded_config do
            if PortalModule.configuration.orgs.key?(orgname)
              PortalModule.configuration.orgs.delete(orgname)
            end
          end
        end

        desc "credentials <envname>", "delete credentials for an environment"
        def credentials(envname)
          with_loaded_config do
            if PortalModule.configuration.credentials.key?(envname.to_sym)
              PortalModule.configuration.credentials.delete(envname.to_sym)
            end
          end
        end

      private

        def with_loaded_config &block
          fail "expecting block" unless block_given?

          unless PortalModule.load_configuration
            say "Configuration file not found!", :red
            say "Have you tried 'config init' first?"
            return
          end

          yield

          PortalModule.save_configuration
        end
      end

      desc "del [CATEGORY]", "delete a configuration value for [CATEGORY]"
      subcommand "del", Del

      ###
      # init command
      #

      desc "init <filedir>", "create a configuration file"
      long_desc <<-LD
        Initialize and write a configuration file to disk.

        If <filedir> is provided, config file will be written to the
        given directory.

        If <filedir> is not given, the configuration file will be
        written to the current working directory.

        If you do not yet have a configuration file, this command
        should be run before any other modifications so your config
        changes are safely stored.
      LD
      option :quiet, :type => :boolean, :default => false, :aliases => :q
      def init(filedir = nil)
        outpath = PortalModule.save_configuration filedir
        say("configuration written to #{outpath.to_s}", :green) unless options[:quiet]
      end

      ###
      # timeout command
      #

      desc "timeout <seconds>", "show or set the browser timeout period"
      long_desc <<-LD
        Show or set the browser timeout period.
        Default value is 360.

        If <seconds> is not provided, display the current setting.

        <seconds> must be an integer value.
      LD
      def timeout(seconds=nil)
        if seconds.nil?
          with_loaded_config do
            say "browser timeout: #{PortalModule.configuration.browser_timeout}"
          end
        else
          seconds = Integer(seconds)
          with_loaded_config(true) do
            PortalModule.configuration.browser_timeout = seconds
          end
        end
      rescue ArgumentError => e
        say 'argument error: seconds must be an integer', :red
      end

      ###
      # defenv command
      #

      desc "defenv <envname>", "show or set the default environment"
      long_desc <<-LD
        Show or set the default environment.

        If <envname> is not provided, display the current setting.

        <envname> must be an existing environment.
      LD
      def defenv(envname=nil)
        if envname.nil?
          with_loaded_config do
            say "default environment: #{PortalModule.configuration.default_environment}"
          end
          return
        end

        with_loaded_config(true) do
          if PortalModule.configuration.base_urls.key? envname.to_sym
            PortalModule.configuration.default_environment = envname.to_sym
          else
            say "argument error: environment '#{envname}' has not been configured", :red
          end
        end
      end

      ###
      # download_dir command
      #

      desc "download_dir <dir>", "show or set the system download directory"
      long_desc <<-LD
        Show or set the system download directory.

        If <dir> is not provided, display the current setting.
      LD
      def download_dir(dir=nil)
        if dir.nil?
          with_loaded_config do
            say "download dir: #{PortalModule.configuration.download_dir}"
          end
          return
        end

        with_loaded_config(true) do
          PortalModule.configuration.download_dir = dir
        end
      end

    private

      def with_loaded_config save = false
        fail "expecting block" unless block_given?

        unless PortalModule.load_configuration
          say "Configuration file not found!", :red
          say "Have you tried 'config init' first?"
          return
        end

        yield

        PortalModule.save_configuration if save
      end
    end # Config
  end # Command
end # PortalModule

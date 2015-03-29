##############################################################################
# File::    cli.rb
# Purpose:: Portal Module command line interface
# 
# Author::    Jeff McAffee 2015-03-27
##############################################################################

require 'thor'
require 'portal_module/command'


module PortalModule
  class CLI < Thor

    def self.start(*)
      super
    rescue Exception => e
      raise e
    end

    def initialize(*args)
      super
    end

    desc "config [COMMAND]", "modify configuration values"
    subcommand "config", PortalModule::Command::Config

    desc "dts [COMMAND]", "run a dts command"
    subcommand "dts", PortalModule::Command::Dts

    desc "loan_entry [COMMAND]", "run a Loan Entry command"
    subcommand "loan_entry", PortalModule::Command::LoanEntry
  end # CLI
end # PortalModule


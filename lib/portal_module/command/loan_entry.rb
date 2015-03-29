##############################################################################
# File::    loan_entry.rb
# Purpose:: LoanEntry command line interface
#
# Author::    Jeff McAffee 2015-03-29
##############################################################################

module PortalModule
  module Command
    class LoanEntry < Thor
      include ClientAccess

      class_option :environment, :banner => "dev", :aliases => :e

      desc "upload <org> <filepath>",
        "Upload a Loan Entry configuration file into the environment"
      long_desc <<-LD
        Import a Loan Entry configuration file into the environment.

        <org> name of Org Unit to import changes to.

        <filepath> is a path to a XML configuration file to import.

        With -e <env>, sets the environment to work with.

        Examples:

        * portal_module loan_entry upload -e dev 'Test Org' path/to/my/file.xml

        * portal_module loan_entry upload -e dev 'Test Org' 'path with space/to/my/file.xml'
      LD
      def upload org, filepath
        cs = client.loan_entry
        cs.upload org, filepath

      ensure
        client.logout
      end

      desc "download <org> <filepath>",
        "Download a Loan Entry configuration file from the environment"
      long_desc <<-LD
        Export a Loan Entry configuration file from the environment.

        <org> name of Org Unit to export changes from.

        <filepath> path where the XML configuration file will be exported to.

        With -e <env>, sets the environment to work with.

        Examples:

        * portal_module loan_entry download -e dev 'Test Org' path/to/my/file.xml

        * portal_module loan_entry download -e dev 'Test Org' 'path with space/to/my/file.xml'
      LD
      def download org, filepath
        cs = client.loan_entry
        cs.download org, filepath

      ensure
        client.logout
      end
    end # class
  end # Command
end # module

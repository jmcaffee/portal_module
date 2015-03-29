##############################################################################
# File::    dts.rb
# Purpose:: DTS command line interface
#
# Author::    Jeff McAffee 2015-03-27
##############################################################################

module PortalModule
  module Command
    class Dts < Thor
      include ClientAccess

      class_option :environment, :banner => "dev", :aliases => :e

      desc "upload <org> <filepath>",
        "Upload a DTS configuration file into the environment"
      long_desc <<-LD
        Upload a DTS configuration file into the environment.

        <org> name of the Org Unit to import to.
        The org must be available in the configuration.
        See <config add org>, <config show org>.

        <filepath> is a path to a XML configuration file to import.

        With -e <env>, sets the environment to work with.

        Examples:

        * portal_module dts upload -e dev 'Test Org' path/to/my/file.xml

        * portal_module dts upload -e dev 'Test Org' 'path with space/to/my/file.xml'
      LD
      def upload org, filepath
        cl = client.dts
        cl.upload org, filepath

      ensure
        client.logout
      end

      desc "download <org> <filepath>",
        "Export a DTS configuration file from the environment"
      long_desc <<-LD
        Download a DTS configuration file from the environment.

        <org> name of the Org Unit to export from.
        The org must be available in the configuration.
        See <config add org>, <config show org>.

        <filepath> path where the XML configuration file will be exported to.

        With -e <env>, sets the environment to work with.

        Examples:

        * portal_module dts download -e dev 'Test Org' path/to/my/file.xml

        * portal_module dts download -e dev 'Test Org' 'path with space/to/my/file.xml'
      LD
      def download org, filepath
        cl = client.dts
        cl.download org, filepath

      ensure
        client.logout
      end
    end # Dts
  end # Command
end # PortalModule

##############################################################################
# File::    dts.rb
# Purpose:: Interface to DTS functionality in portal module
# 
# Author::    Jeff McAffee 2015-03-27
##############################################################################

require 'portal_module/pages'
require 'portal_module/assertable'

module PortalModule

  class Dts
    include Assertable

    DL_FILENAME = '2-LatestDTS.xml'

    attr_reader :page_factory

    def initialize(page_factory)
      @page_factory = page_factory
    end

    def save
      dts_page.save
    end

    def activate
      dts_page.activate
    end

    def set_org org
      assert_org_is_configured org
      dts_page.load_org(org)
    end

    def download org, file_path
      assert_org_is_configured org
      assert_dl_dir_is_configured
      assert_dir_exists file_path

      dts_page
        .load_org(org)
        .download

      file_path = Pathname(file_path)
      file_path = file_path + DL_FILENAME if file_path.directory?

      dl_file = download_dir + DL_FILENAME
      assert_file_exists dl_file

      FileUtils.mv dl_file, file_path

    rescue Exception => e
      if e.message.include? 'No such file or directory'
        raise IOError, "No such directory - #{file_path}"
      else
        raise e
      end
    end

    ##
    # Import DTS configurations into the current environment from a file.

    def upload org, file_path
      assert_org_is_configured org
      assert_file_exists file_path

      # FIXME: Needs to be an expanded path
      dts_page
        .load_org(org)
        .upload(file_path)
    end

  private

    def dts_page
      page_factory.dts_page
    end

    def download_dir
      Pathname(PortalModule.configuration.download_dir)
    end
  end # class Dts
end # module

##############################################################################
# File::    loan_entry.rb
# Purpose:: filedescription
#
# Author::    Jeff McAffee 2015-03-27
##############################################################################

require 'portal_module/pages'
require 'portal_module/assertable'

module PortalModule

  class LoanEntry
    include Assertable

    DL_FILENAME = '2-LatestPrequal.xml'

    attr_reader :page_factory

    def initialize page_factory
      @page_factory = page_factory
    end

    def activate
      loan_entry_page
        .activate
    end

    def set_org org
      assert_org_is_configured org
      loan_entry_page.load_org(org)
    end

    ##
    # Export loan entry data for an org unit to a file

    def download org, file_path
      assert_org_is_configured org
      assert_dl_dir_is_configured
      assert_dir_exists file_path

      loan_entry_page
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
    # Import loan entry data from a file
    #

    def upload org, file_path
      assert_org_is_configured org
      assert_file_exists file_path

      loan_entry_page
        .load_org(org)
        .upload(Pathname(file_path).expand_path)
    end

  private

    def loan_entry_page
      page_factory.loan_entry_page
    end

    def download_dir
      Pathname(PortalModule.configuration.download_dir)
    end
  end # class
end # module
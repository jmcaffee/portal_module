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
<<<<<<< HEAD
      dts_page.load_org(org)
=======
      dts_page.load_org(org_string(org))
>>>>>>> b947a5d3cfb546e2133836adecd77d0487b4ff77
    end

    def download org, file_path
      assert_org_is_configured org
      assert_dl_dir_is_configured
      assert_dir_exists file_path

      dts_page
<<<<<<< HEAD
        .load_org(org)
=======
        .load_org(org_string(org))
>>>>>>> b947a5d3cfb546e2133836adecd77d0487b4ff77
        .download

      file_path = Pathname(file_path)
      file_path = file_path + DL_FILENAME if file_path.directory?

      dl_file = download_dir + DL_FILENAME
<<<<<<< HEAD
=======
      wait_for_file(dl_file, PortalModule.configuration.download_timeout)
>>>>>>> b947a5d3cfb546e2133836adecd77d0487b4ff77
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

<<<<<<< HEAD
      # FIXME: Needs to be an expanded path
      dts_page
        .load_org(org)
        .upload(file_path)
=======
      dts_page
        .load_org(org_string(org))
        .upload(Pathname(file_path).expand_path)
>>>>>>> b947a5d3cfb546e2133836adecd77d0487b4ff77
    end

  private

    def dts_page
      page_factory.dts_page
    end

    def download_dir
      Pathname(PortalModule.configuration.download_dir)
    end
<<<<<<< HEAD
=======

    def org_string org
      orgid = PortalModule.configuration.orgs[org]
      orgstr = "#{orgid}~#{org}"
    end

    def wait_for_file(file_path, timeout_secs)
      stop_time = Time.now + timeout_secs
      file_path = Pathname(file_path)
      while !file_path.exist?
        break if stop_time <= Time.now
        sleep 1
      end
    end
>>>>>>> b947a5d3cfb546e2133836adecd77d0487b4ff77
  end # class Dts
end # module

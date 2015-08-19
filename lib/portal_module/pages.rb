##############################################################################
# File::    pages.rb
# Purpose:: Require all Page classes
#
# Author::    Jeff McAffee 2015-03-28
##############################################################################

require 'watir-webdriver'
require 'ktutils/os'
require 'portal_module/pages/login_page'
require 'portal_module/pages/data_transformation_page'
require 'portal_module/pages/prequal_setup_page'

module PortalModule::Pages

  ##
  # Return a configured browser object. If a browser has already been created,
  # this returns the existing browser.
  #
  # An +at_exit+ proc is created to close the browser when the program exits.

  def browser
    if @browser.nil?
      @browser = configure_browser

      at_exit do
        @browser.close unless @browser.nil?
      end
    end

    @browser
  end

private

  def chromium_exe
    if Ktutils::OS.windows?
      # Downloaded from http://chromium.woolyss.com/
      # Package: Chromium Package (32-bit)
      # Version: 37.0.2011.0 (272392)
      chromium_exe = ENV["chrome_browser_path"]
      unless (! chromium_exe.nil? && ! chromium_exe.empty? && File.exist?(chromium_exe))
        raise "chrome_browser_path environment variable not set"
      end
      #chromium_exe = File.absolute_path(File.join(__FILE__, '../../../bin/chrome-win32/chrome.exe'))
      chromium_exe
    else
      chromium_exe = `which chromium-browser`.chomp
    end
  end

  def configure_browser
    # We must clear out any environmental proxy or Selenium fails
    # to connect to the local application.
    # See http://zagorskisoftwaretester.blogspot.com/2015/02/httpproxy-environment-variable-override.html
    ENV['http_proxy'] = nil

    # Specify chrome browser capabilities.
    caps = Selenium::WebDriver::Remote::Capabilities.chrome
    caps['chromeOptions'] = {'binary' => chromium_exe }
    #caps['chromeOptions'] = {'binary' => '/opt/bin/test/chrome-27.0.1453.94.exe' }
    # See http://peter.sh/experiments/chromium-command-line-switches/ for a list of available switches.
    # See https://sites.google.com/a/chromium.org/chromedriver/capabilities for details on setting ChromeDriver caps.

    # NOTE: The only way I've found to stop the EULA from being displayed is to
    # use the user-data-dir switch and point to a dir where chrome can put the
    # data indicating it (EULA) has already been accepted.

    # Store chrome profile at test/chrome-data.
    # user_data_dir must be expanded to a full (absolute) path. A relative path
    # results in chromedriver failing to start.
    user_data_dir = File.expand_path('test/chrome-data')
    #puts "*** user_data_dir location: #{user_data_dir}"

    # Create the data dir if it doesn't exist (or chromedriver fails to start).
    unless File.exists?(user_data_dir) and File.directory?(user_data_dir)
      FileUtils.makedirs user_data_dir
    end

    # ignore-certificate-errors:  Ignores certificate-related errors.
    # disable-popup-blocking:     Disable pop-up blocking.
    # disable-translate:          Allows disabling of translate from the command line to assist with automated browser testing
    # no-first-run:               Skip First Run tasks, whether or not it's actually the First Run.
    # log-level:                  Sets the minimum log level. Valid values are from 0 to 3: INFO = 0, WARNING = 1, LOG_ERROR = 2, LOG_FATAL = 3.
    switches = %w[--ignore-certificate-errors --disable-popup-blocking --disable-translate --no-first-run --log-level=3]
    switches << "--user-data-dir=#{user_data_dir}"

    # Create a client so we can adjust the timeout period.
    client = Selenium::WebDriver::Remote::Http::Default.new

    # Set the browser timeout. Default is 60 seconds.
    client.timeout = PortalModule.configuration.browser_timeout

    browser = Watir::Browser.new :chrome,
      :switches => switches,
      :http_client => client,
      :service_log_path => user_data_dir + '/chromedriver.out',
      :desired_capabilities => caps
  end
end

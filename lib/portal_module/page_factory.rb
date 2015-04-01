##############################################################################
# File::    page_factory.rb
# Purpose:: Provides Page objects
<<<<<<< HEAD
# 
# Author::    Jeff McAffee 06/30/2014
# Copyright:: Copyright (c) 2014, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
=======
#
# Author::    Jeff McAffee 2015-03-29
#
>>>>>>> b947a5d3cfb546e2133836adecd77d0487b4ff77
##############################################################################

require 'portal_module/pages'

module PortalModule
  class PageFactory
    include PortalModule::Pages

    def login_page(goto_page = true)
      return Pages::LoginPage.new(browser, goto_page)
    end

    def dts_page(goto_page = true)
      return Pages::DataTransformationPage.new(browser, goto_page)
    end

    def loan_entry_page(goto_page = true)
      return Pages::PrequalSetupPage.new(browser, goto_page)
    end
  end
end # PortalModule

##############################################################################
# File::    prequal_setup_page.rb
# Purpose:: Loan Entry Setup page for PortalModule
# 
# Author::    Jeff McAffee 2015-03-28
##############################################################################
require 'page-object'

module PortalModule::Pages

  class PrequalSetupPage
    include PageObject

    #page_url(:get_dynamic_url)

    def get_dynamic_url
      PortalModule.configuration.url(PrequalSetupPage)
    end

    button(:activate_button,
          id: 'ctl00_ContentPlaceHolder1_btnVersion')

    button(:download_button,
          id: 'ctl00_ContentPlaceHolder1_btnDownload')

    # Search Orgs
    text_field(:search_text,
          id: 'ctl00_ContentPlaceHolder1_txtSrchText')

    button(:search_button,
          id: 'ctl00_ContentPlaceHolder1_btnSearch')

    # File Upload
    file_field(:file_input,
          id: 'ctl00_ContentPlaceHolder1_hdnFileUploader')

    button(:upload_button,
          id: 'ctl00_ContentPlaceHolder1_btnUploadXMLFile')


    def activate
      self.activate_button
      self
    end

    def download
      self.download_button
      self
    end

    def load_org org_string
      self.search_text = org_string
      self.search_button
      self
    end

    def upload file_path
      self.file_input = file_path
      self.upload_button
      self
    end
  end
end # module

